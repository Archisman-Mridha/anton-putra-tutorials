resource "aws_launch_template" "this" {
  vpc_security_group_ids = [ aws_security_group.ec2.id ]

  image_id = local.ami
  key_name = aws_key_pair.this.key_name
}

resource "aws_autoscaling_group" "this" {
  min_size = 1
  max_size = 3

  vpc_zone_identifier = [ aws_subnet.private_subnet.id ]

  health_check_type = "EC2"

  // Registering this autoscaling group as the target for the ALB.
  target_group_arns = [ aws_lb_target_group.app.arn ]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.this.id
      }

      override {
        instance_type = var.aws_instance_type
      }
    }
  }
}

// If avergae CPU utilization across all existing EC2 instances
// cross 25%, then spin up new EC2 machines inside the autoscaling
// group.
resource "aws_autoscaling_policy" "this" {
  name = "cpu_based_autoscaling_policy"

  policy_type = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.this.name

  estimated_instance_warmup = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 25.0
  }
}