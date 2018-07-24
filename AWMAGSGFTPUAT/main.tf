provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "eu-west-2"
}

resource "aws_vpc" "VPC1" {
  cidr_block = "10.0.0.0/23"

  tags {
    Name = "AWMAGRGVPC1"
  }
}

resource "aws_subnet" "SNET11" {
  vpc_id = "${aws_vpc.VPC1.id}"
  cidr_block = "10.0.0.0/24"

  tags {
    Name = "AWMAGRGVPC1"
  }
}
