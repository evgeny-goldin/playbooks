#!/bin/bash

. aws.sh

placement_group='TestRepo'
inventory_file='inventory'
connect="-i $inventory_file -u $AWS_SSH_USER --private-key=$AWS_SSH_PRIVATE_KEY"
reports=/opt/gatling-reports
reports_archive=/opt/gatling-reports.tar.gz

clear
echo '------------------------------------------'
echo "         Creating 2 EC2 instances"
echo '------------------------------------------'
echo "Region:   $AWS_DEFAULT_REGION"
echo "Type:     $AWS_INSTANCE_TYPE"
echo "EBS Size: $AWS_EBS_SIZE"
echo "Keypair:  $AWS_KEYPAIR_NAME"
echo "SSH key:  $AWS_SSH_PRIVATE_KEY"
echo '------------------------------------------'
echo "Press Enter to continue" && read

if [ $(aws ec2 describe-placement-groups --group-names "$placement_group" --output text 2>/dev/null | wc -l) == "0" ]; then
  echo "== Creating Placement Group '$placement_group'"
  aws ec2 create-placement-group --group-name "$placement_group" --strategy cluster
fi

echo "== Creating EC2 instances"
instance_ids=$(aws ec2 run-instances \
              --count                 "2" \
              --region                "$AWS_DEFAULT_REGION" \
              --image-id              "$AWS_AMI" \
              --key-name              "$AWS_KEYPAIR_NAME" \
              --instance-type         "$AWS_INSTANCE_TYPE" \
              --block-device-mappings "[{ \"DeviceName\" : \"/dev/sda1\", \"Ebs\":{ \"VolumeSize\" : $AWS_EBS_SIZE }}]" \
              --subnet-id             "$AWS_SUBNET_ID" \
              --monitoring            "Enabled=value" \
              --query                 "Instances[*].InstanceId" \
              --output                "text" \
              --associate-public-ip-address \
              --placement             "AvailabilityZone=${AWS_DEFAULT_REGION}a,GroupName=${placement_group},Tenancy=default" \
              --ebs-optimized | tr '\t' ' ')

ids=(${instance_ids// / });
aws ec2 create-tags --resources "${ids[0]}" --tags "Key=Name,Value=Repo"
aws ec2 create-tags --resources "${ids[1]}" --tags "Key=Name,Value=Test-Repo"

echo "== Waiting for instances to start"
state=''
while [ "$state" != "running" ]; do
  sleep 5
  printf '.'
  state=$(aws ec2 describe-instances --instance-ids $instance_ids --query "Reservations[*].Instances[*].State.Name" --output text | tr '\t' '\n' | sort -u)
done
printf '\r                                                          \r'

echo "== Reading instances IPs"
repo_ip=$(aws ec2 describe-instances --instance-ids "${ids[0]}" --query "Reservations[*].Instances[*].PublicIpAddress" --output text)
test_repo_ip=$(aws ec2 describe-instances --instance-ids "${ids[1]}" --query "Reservations[*].Instances[*].PublicIpAddress" --output text)
echo "== IPs are [$repo_ip] and [$test_repo_ip]"

for ip in $repo_ip $test_repo_ip; do
  command="ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no -i $AWS_SSH_PRIVATE_KEY $AWS_SSH_USER@$ip id"
  echo "== Waiting for [$command]"
  output=''
  while ! [[ "$output" =~ "$AWS_SSH_USER" ]]; do
    sleep 5
    printf '.'
    output=$($command 2>&1)
  done
  printf '\r                                                          \r'
done

echo "== Creating '$inventory_file': [repo] is $repo_ip, [test-repo] is $test_repo_ip"
cat << EOF > "$inventory_file"
[repo]
$repo_ip

[test-repo]
$test_repo_ip
EOF

echo "== Running Artifactory playbook"
set -x
ansible-playbook 'playbooks/artifactory-ubuntu.yml' $connect --extra-vars "port=$REPO_PORT import='$REPO_IMPORT' java_options='$REPO_JAVA_OPTIONS'"
set +x

echo "== Running Test Artifactory playbook"
set -x
ansible-playbook 'playbooks/test-repo-ubuntu.yml' $connect --extra-vars "host=$repo_ip port=$REPO_PORT clean_reports=true reports_dir='$reports' reports_archive='$reports_archive' repo_name=Artifactory path=/artifactory/repo/"
set +x

echo "== Running Nexus playbook"
set -x
ansible-playbook 'playbooks/nexus-ubuntu.yml' $connect --extra-vars "port=$REPO_PORT import='$REPO_IMPORT' java_options='$REPO_JAVA_OPTIONS'"
set +x

echo "== Running Test Nexus playbook"
set -x
ansible-playbook 'playbooks/test-repo-ubuntu.yml' $connect --extra-vars "host=$repo_ip port=$REPO_PORT reports_dir='$reports' reports_archive='$reports_archive' repo_name=Nexus path=/nexus/content/repositories/central/"
set +x

echo "== Downloading reports archive"
set -x
scp -i $AWS_SSH_PRIVATE_KEY "$AWS_SSH_USER@$test_repo_ip:$reports_archive" .
set +x

echo "== Terminating EC2 instances"

echo "== Deleting Placement Group '$placement_group'"
# aws ec2 delete-placement-group --group-name "$placement_group"
