
# =============================================================================================================
# Modify the variables below accorind to your AWS account and save this file as "aws.sh" in the same directory
# =============================================================================================================

export AWS_DEFAULT_REGION="eu-west-1"
export AWS_KEYPAIR_NAME="..."
export AWS_SSH_PRIVATE_KEY="..."
export AWS_SUBNET_ID="..."
export AWS_SECURITY_GROUP_ID="..." # Allow ports 22, 8080 Inbound and all ports Outbound
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."

# =============================================================================================================
# Only modify the variables below if you know what you're doing
# =============================================================================================================

export AWS_AMI="ami-f0b11187"
export AWS_INSTANCE_TYPE="c4.2xlarge"
export AWS_EBS_SIZE="20"
export AWS_SSH_USER="ubuntu"

export REPO_PORT="8080"
export ARTIFACTORY_JAVA_OPTIONS="-server -Xms512m -Xmx14000m"
export NEXUS_JAVA_OPTIONS="-server -Xms512m -Xmx14000m"
export REPO_IMPORT="https://dropbox.artifactoryonline.com/dropbox/stress-test-dataset/repo-import.zip"
