output "rds_secret_arn" {
  value = data.aws_secretsmanager_secret.apci_rds_secret.arn
}