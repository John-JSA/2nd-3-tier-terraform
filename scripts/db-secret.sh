aws secretsmanager create-secret \
    --name rdsmysql4 \
    --secret-string '{"password":"=soktoll1723akldja;lebndaf"}' \
    --description "RDS MySQL password for Terraform" \
    --region us-east-2
#TO Verify the Secret:
aws secretsmanager get-secret-value --secret-id rdsmysql4