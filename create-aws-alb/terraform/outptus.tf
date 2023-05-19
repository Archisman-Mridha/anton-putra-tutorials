output "ami" {
  description = "custom AMI running our app"
  value = local.ami
}

output "alb_dnsname" {
  description = "DNS name of the provisioned ALB"
  value = aws_lb.this.dns_name
}

output "vm_public_ip" {
  value = aws_instance.this.public_ip
}