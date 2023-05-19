resource "null_resource" "packer_apply" {
  provisioner "local-exec" {
    when = create
    on_failure = fail

    working_dir = "../packer/"
    command = <<-EOC

      tee -a variables.auto.pkrvars.hcl <<EOF
        aws_access_key = "${var.aws_access_key}"
        aws_secret_key = "${var.aws_secret_key}"
        source_subnet_id = "${aws_subnet.public_subnet.id}"
        project_name = "${var.project_name}"
      EOF

      packer init .

      packer build . 2>&1 | tee output.txt
      tail -2 output.txt | head -2 | awk 'match($0, /ami-.*/) { print substr($0, RSTART, RLENGTH) }' > ami.txt

      rm variables.auto.pkrvars.hcl
    EOC
  }

  // Packer cannot destroy AMIs.
  // So we need to destroy the AMIs manually.
}

data "local_file" "ami" {
  filename = "../packer/ami.txt"
}

locals {
  ami = flatten(regexall("[a-zA-Z0-9-]+", data.local_file.ami.content))[0]
}