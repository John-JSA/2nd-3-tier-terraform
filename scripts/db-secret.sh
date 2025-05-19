aws secretsmanager create-secret \
    --name rdsmysql2 \
    --secret-string '{"password":"=soktoll1723akldja;lebndaf"}' \
    --description "RDS MySQL password for Terraform"

#TO Verify the Secret:
aws secretsmanager get-secret-value --secret-id rdsmysql2