# Version 6
provider "aws" {
  region = "us-east-1"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

resource "aws_instance" "RadditwithFile" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
  count = 1
  key_name   = "Default"
  security_groups = ["launch-wizard-1"]
}
