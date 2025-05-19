output "apci_alb_sg_id" {
  value = aws_security_group.apci_alb_sg.id
}

output "apci_target_group_arn" {
  value = aws_lb_target_group.apci_target_group.arn
}

