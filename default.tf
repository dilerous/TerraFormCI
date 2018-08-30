# Version 7
provider "aws" {
  region = "us-east-1"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

terraform {
  backend "s3" {
    bucket = "brad.bucket"
    key    = "terraform"
    region = "us-east-1"
  }
}

resource "aws_instance" "RadditwithFile" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
  count = 1
  key_name   = "Default"
  security_groups = ["launch-wizard-1"]

  provisioner "file" {
    source      = "configuration.sh"
    destination = "/tmp/configuration.sh"
    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file("~/.ssh/id_rsa_e7b9b011c0608d0ab820830ab7c0d048")}"
              }
}
  provisioner "file" {
    source      = "ubuntu.service"
    destination = "/tmp/ubuntu.service"
    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file("~/.ssh/id_rsa_e7b9b011c0608d0ab820830ab7c0d048")}"
              }
}
  provisioner "remote-exec" {
   inline = [
     "chmod +x /tmp/configuration.sh",
     "chmod +x /tmp/ubuntu.service",
     "sudo /tmp/configuration.sh"
            ]
            connection {
                type = "ssh"
                user = "ubuntu"
                private_key = "${file("~/.ssh/id_rsa_e7b9b011c0608d0ab820830ab7c0d048")}"
                      }
}
}
