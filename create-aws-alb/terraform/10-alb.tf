resource "aws_lb" "this" {
  load_balancer_type = "application"
  internal = false

  subnets = [ aws_subnet.public_subnet.id, aws_subnet.extra_public_subnet.id ]

  security_groups = [ aws_security_group.alb.id ]
}

resource "aws_lb_target_group" "app" {
  port = 8080
  protocol = "HTTP"

  health_check {
    enabled = true

    port = 8081
    interval = 30
    protocol = "HTTP"
    path = "/healthcheck"
    matcher = "200"

    healthy_threshold = 3
    unhealthy_threshold = 3
  }

  vpc_id = aws_vpc.this.id
}

resource "aws_lb_target_group_attachment" "app_lb_attachment" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id = aws_instance.this.id

  port = 8080
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn

  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn = aws_lb_target_group.app.arn
      }
    }
  }
}