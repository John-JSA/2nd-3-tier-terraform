resource "aws_security_group" "apci_alb_sg" {
  name        = "apci_alb_sg"
  description = "Allow http and https traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-alb_sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "apci_alb_http" {
  security_group_id = aws_security_group.apci_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

#resource "aws_vpc_security_group_ingress_rule" "allow_tls_https" {
 # security_group_id = aws_security_group.allow_tls.id
  #cidr_ipv6         = aws_vpc.main.ipv6_cidr_block
  #from_port         = 443
  #ip_protocol       = "tcp"
  #to_port           = 443
#}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.apci_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# CRETING A TARGET GROUP
resource "aws_lb_target_group" "apci_target_group" {
  name        = "apci-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

    health_check {
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200,301,302"
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

#CREATING ALB
resource "aws_lb" "apci_alb" {
  name               = "apci-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.apci_alb_sg.id]
  subnets            = [var.apci_frontend_subnet_az2a_id, var.apci_frontend_subnet_az2b_id]

  enable_deletion_protection = false

  #access_logs {
    #bucket  = aws_s3_bucket.lb_logs.id
    #prefix  = "test-lb"
    #enabled = true
  #}

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-alb"
  })
}


#CREATING ALB LISTENERS ON PORT 80 WITH REDIRECT ACTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
resource "aws_lb_listener" "apci_alb_http_listener" {
  load_balancer_arn = aws_lb.apci_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"

    #redirect {
     # port        = "443"
      #protocol    = "HTTPS"
      #status_code = "HTTP_301"
    #}
  #}
#}

#creating listener for https on port 443 with a forward action (ssl certicate and default action) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#resource "aws_lb" "front_end" {
  # ...
#}

#resource "aws_lb_target_group" "front_end" {
  # ...
#}

#resource "aws_lb_listener" "apci_https_alb_listener" {
 # load_balancer_arn = aws_lb.apci_alb.arn
  #port              = "443"
  #protocol          = "HTTPS"
  #ssl_policy        = var.ssl_policy
  #certificate_arn   = var.certificate_arn

  #default_action {
    #type             = "forward"
    target_group_arn = aws_lb_target_group.apci_target_group.arn
  #}
}

}

# Register EC2 instance to target group
#resource "aws_lb_target_group_attachment" "" {
 # target_group_arn = aws_lb_target_group.apci_target_group.arn
  #target_id        = "i-0808710d76d826ea7"  # Replace with your EC2 instance ID
  #port             = 80
#\}