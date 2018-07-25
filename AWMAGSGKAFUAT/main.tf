provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "eu-west-2"
}

resource "aws_vpc" "vpc2" {
  cidr_block = "172.168.0.0/16"

  tags {
    Name = "AWMAGVPC2"
    Resource_Group = "AWMAGRGVPC2"
  }
}
