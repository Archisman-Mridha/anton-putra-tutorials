packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.5"
      source = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "app" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  region = var.aws_region
  subnet_id = var.source_subnet_id

  ami_name = "app-{{ timestamp }}"
  instance_type = var.source_instance_type

  source_ami_filter {
    // Canonical
    owners = ["099720109477"]

    most_recent = true
    filters = {
      name = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type = "ebs"
      virtualization-type = "hvm"
    }
  }

  ssh_username = "ubuntu"

  tags = {
    project = var.project_name
  }
}

build {
  sources = ["source.amazon-ebs.app"]

  // Copy SystemD service file
  provisioner "file" {
    destination = "/tmp"
    source = "files"
  }

  // Install the Go application
  provisioner "shell" {
    script = "scripts/bootstrap.sh"
  }

  // Start the Go application
  provisioner "shell" {
    inline = [
      <<-EOC
        sudo mv /tmp/files/app.service /etc/systemd/system/app.service
        sudo systemctl start app &&
          sudo systemctl enable app
      EOC
    ]
  }
}