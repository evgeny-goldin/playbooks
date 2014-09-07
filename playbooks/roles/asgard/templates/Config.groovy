grails {
	awsAccounts=['{{ AWS_ACCOUNT_ID }}']
	awsAccountNames=['{{ AWS_ACCOUNT_ID }}':'prod']
}
secret {
	accessId='{{ AWS_ACCESS_KEY_ID }}'
	secretKey='{{ AWS_SECRET_ACCESS_KEY }}'
}
cloud {
	accountName='prod'
	publicResourceAccounts=['amazon']
}
