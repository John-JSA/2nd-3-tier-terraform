# auto-scaling security group
resource "aws_security_group" "apci_jupiter_asg" {
  name        = "apci-asg-sg"
  description = "Allow ssh, http and https traffic"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-auto-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ingress_rule" {
  security_group_id = aws_security_group.apci_jupiter_asg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "http_ingress_rule" {
  security_group_id = aws_security_group.apci_jupiter_asg.id
  referenced_security_group_id = var.apci_alb_sg_id  
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
#resource "aws_vpc_security_group_ingress_rule" "allow_tls_https" {
  #security_group_id = aws_security_group.allow_tls.id
  #cidr_ipv6         = aws_vpc.main.ipv6_cidr_block
  #from_port         = 443
  #ip_protocol       = "tcp"
  #to_port           = 443
#}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.apci_jupiter_asg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# CREATING LAUNCH TEMPLATE FOR JUPITER SERVER --------------------------------------
resource "aws_launch_template" "apci_jupiter_lt" {
  name_prefix   = "apci-jupiter-lt"
  image_id      = var.image_id
    instance_type = var.instance_type
  key_name = var.key_name
  user_data = base64encode(file("scripts/frontend-jupiter-app.sh"))

    network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.apci_jupiter_asg.id]
  }
}


resource "aws_autoscaling_group" "apci_jupiter_asg" {
  name                      = "apci-jupiter-asg"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true
  vpc_zone_identifier       = [var.apci_frontend_subnet_az2a_id, var.apci_frontend_subnet_az2b_id]
  target_group_arns         = [var.apci_target_group_arn]

  launch_template {
    id      = aws_launch_template.apci_jupiter_lt.id
    version = "$Latest"

  }
  tag {
    key                 = "Name"
    value               = "apci-jupiter-app-server"
    propagate_at_launch = true
  }
}




