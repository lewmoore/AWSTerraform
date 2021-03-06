terraform {
  backend "local" {}
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "eu-west-2"
}

resource "aws_vpc" "VPC1" {
  cidr_block = "10.0.0.0/23"

  tags {
    Name = "AWMAGVPC1"
    Resource_Group = "AWMAGRGVPC1"
  }
}

resource "aws_subnet" "SNET11" {
  vpc_id = "${aws_vpc.VPC1.id}"
  cidr_block = "10.0.0.0/24"

  tags {
    Name = "AWMAGSNET11"
    Resource_Group = "AWMAGRGVPC1"
  }
}

resource "aws_internet_gateway" "FTPUATIGW" {
  vpc_id = "${aws_vpc.VPC1.id}"

  tags {
    Resource_Group = "AWMAGRGFTPUAT"
  }
}

resource "aws_network_interface" "AWMAGNIC11" {
  subnet_id = "${aws_subnet.SNET11.id}"
  private_ips = ["10.0.0.4"]
  security_groups = ["${aws_security_group.FTPUATSG.id}"]

  tags {
    Resource_Group = "AWMAGRGFTPUAT"
  }
}

resource "aws_route_table" "ftpuatrt" {
  vpc_id = "${aws_vpc.VPC1.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.FTPUATIGW.id}"
  }
}

resource "aws_route_table_association" "main" {
    subnet_id = "${aws_subnet.SNET11.id}"
    route_table_id = "${aws_route_table.ftpuatrt.id}"
}


resource "aws_eip" "FTPUATEIP" {
  instance = "${aws_instance.FTPUATVM.id}"
  vpc      = true
  network_interface = "${aws_network_interface.AWMAGNIC11.id}"

  tags {
    Resource_Group = "AWMAGRGFTPUAT"
  }
}

data "aws_ami" "amazon_windows_2016" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-Base-2018.06.13"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_instance" "FTPUATVM" {
  ami           = "${data.aws_ami.amazon_windows_2016.id}"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = "${aws_network_interface.AWMAGNIC11.id}"
    device_index = 0
    }

  tags {
    Name = "AWSMAGVMFTPUAT"
    Resource_Group = "AWMAGRGFTPUAT"
  }
}
