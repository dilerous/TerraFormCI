# Version 7

# Defines the type of resource that will be created and the region in AWS the instance will be deployed.
provider "aws" {
  region = "us-east-1"
}

# Stores the terraform state file in S3 bucket.
 terraform {
  backend "s3" {
    bucket = "brad.bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
}
}

# Defines the AWS instance, provides SSH credentials for access. Uploads configuration.sh to the local /tmp directory.
 resource "aws_instance" "RadditwithFile" {
    jmi           = "ami-2757f631"
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

# Uploads the ubuntu.service file to the /tmp directory. This file is used during when the configuration.sh script is ran.
  provisioner "file" {
    source      = "ubuntu.service"
    destination = "/tmp/ubuntu.service"
    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file("~/.ssh/id_rsa_e7b9b011c0608d0ab820830ab7c0d048")}"
}
}

# Makes the configuration and ubuntu.service file executable by root accounts. Then the configuration.sh is ran.
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
