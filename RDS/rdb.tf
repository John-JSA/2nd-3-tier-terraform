resource "aws_db_subnet_group" "apci_db_subnet_group" {
  name       = "apci-db-subnet-group"
  subnet_ids = [var.apci_db_subnet_az2a_id, var.apci_db_subnet_az2b_id]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-subnet-az2b"
  })
}

#CREATING RDS SECURITY GROUP ---------------------------------------------------------
resource "aws_security_group" "apci_rds_sg" {
  name        = "apci-rds-sg"
  description = "Allow db traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_rds_traffic"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.apci_rds_sg.id
  referenced_security_group_id = var.bastion_host_id
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.apci_rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# 🔍 Look up the existing secret by name
data "aws_secretsmanager_secret" "apci_rds_secret" {
  name = "rdsmysql2"
}

# 📥 Get the latest version of the secret (to retrieve credentials)
data "aws_secretsmanager_secret_version" "apci_rds_secret_version" {
  secret_id = data.aws_secretsmanager_secret.apci_rds_secret.id
}

## CREATING AN IAM ROLE FOR RDS SECRET MANAGER
#resource "aws_iam_role" "rds_secrets_manager_role" {
  #name = "rds-secrets-manager-role"

  #assume_role_policy = jsonencode({
    #Version = "2012-10-17"
    #Statement = [{
      #Effect = "Allow"
      #Principal = {
     #   Service = "rds.amazonaws.com"
    #  }
   #   Action = "sts:AssumeRole"
  #  }]
 # })
#}

#resource "aws_iam_policy" "secrets_manager_policy" {
  #name        = "rds-secrets-manager-policy"
  #description = "Policy to allow RDS to access Secrets Manager"

  #policy = jsonencode({
    #Version = "2012-10-17"
    #Statement = [
      #{
        #Effect = "Allow"
   #    3 Action = [
      #    "secretsmanager:GetSecretValue"
     #   ]
    #    Resource = "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:rdsmysql2-*" # Make changes here
   #   }
  #  ]
 # })
#}

#resource "aws_iam_role_policy_attachment" "attach_secrets_manager_policy" {
  #role       = aws_iam_role.rds_secrets_manager_role.name
 # policy_arn = aws_iam_policy.secrets_manager_policy.arn
#}

#CREATING THE RDS MYSQL INSTANCE ###############################################terraform aws rds
resource "aws_db_instance" "apci_jupiter_mydb" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.db_username
  password             = jsondecode(data.aws_secretsmanager_secret_version.apci_rds_secret_version.secret_string)["password"]
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.apci_db_subnet_group.name
}