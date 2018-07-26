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

resource "aws_subnet" "snet21" {
  vpc_id = "${aws_vpc.vpc2.id}"
  cidr_block = "172.168.0.0/16"

  tags {
    Name = "AWMAGSNET21"
    Resource_Group = "AWMAGRGVPC2"
  }
}

resource "aws_network_interface" "AWMAGNIC21" {
  subnet_id = "${aws_subnet.snet21.id}"
  private_ips = ["172.168.0.4"]
  security_groups = ["${aws_security_group.kafuatsg.id}"]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
  name   = "name"
  values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
}

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "kafuatvm" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = "${aws_network_interface.AWMAGNIC21.id}"
    device_index = 0
    }
}
