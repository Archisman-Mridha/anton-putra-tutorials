#!/bin/bash

set -e

sudo apt install -y golang-go
git clone --depth 1 https://github.com/Archisman-Mridha/anton-putra-tutorials

tee -a /home/ubuntu/app.run.sh <<EOF
  cd ./anton-putra-tutorials/create-aws-alb/app &&
    go mod download &&
    go run main.go
EOF

chmod +x /home/ubuntu/app.run.sh