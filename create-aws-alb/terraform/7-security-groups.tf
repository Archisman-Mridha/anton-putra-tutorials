resource "aws_security_group" "ec2" {
  vpc_id = aws_vpc.this.id
}

resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.this.id
}

// Allow traffic from ALB to the EC2 instance.
resource "aws_security_group_rule" "ingress_ec2_traffic" {
  type = "ingress"

  from_port = 8080
  to_port = 8080
  protocol = "tcp"

  security_group_id = aws_security_group.ec2.id
  source_security_group_id = aws_security_group.alb.id
}
// Allow healthcheck traffic from ALB to the EC2 instance.
resource "aws_security_group_rule" "ingress_ec2_healthcheck_traffic" {
  type = "ingress"

  from_port = 8081
  to_port = 8081
  protocol = "tcp"

  security_group_id = aws_security_group.ec2.id
  source_security_group_id = aws_security_group.alb.id
}

// Allow internet traffic to port 80 of ALB.
resource "aws_security_group_rule" "ingress_alb_traffic" {
  type = "ingress"

  from_port = 80
  to_port = 80
  protocol = "tcp"

  security_group_id = aws_security_group.alb.id
  cidr_blocks = ["0.0.0.0/0"]
}

// When a security group is created using Terraform,
// all egress traffic is blocked by default. If you want to allow
// egress traffic, you need to additionally mention it as a rule.
// Allow normal egress traffic from ALB to the EC2 instance.
resource "aws_security_group_rule" "egress_alb_traffic" {
  type = "egress"

  from_port = 8080
  to_port = 8080
  protocol = "tcp"

  security_group_id = aws_security_group.alb.id
  source_security_group_id = aws_security_group.ec2.id
}
// Allow healthcheck egress traffic from ALB to the EC2 instance.
resource "aws_security_group_rule" "egress_alb_healthcheck_traffic" {
  type = "egress"

  from_port = 8081
  to_port = 8081
  protocol = "tcp"

  security_group_id = aws_security_group.alb.id
  source_security_group_id = aws_security_group.ec2.id
}

/* // For debugging purposes
resource "aws_security_group_rule" "debug_ec2_ingress" {
  cidr_blocks = [ "0.0.0.0/0" ]

  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"

  security_group_id = aws_security_group.ec2.id
}
resource "aws_security_group_rule" "debug_ec2_egress" {
  cidr_blocks = [ "0.0.0.0/0" ]

  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"

  security_group_id = aws_security_group.ec2.id
} */