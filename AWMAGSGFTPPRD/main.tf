data "terraform_remote_state" "localstate" {
  backend = "local"

  config {
    path = "../AWMAGSGFTPUAT/terraform.tfstate"
  }
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "eu-west-2"
}

resource "aws_subnet" "SNET12" {
  vpc_id = "${data.terraform_remote_state.localstate.aws_vpc}"
  cidr_block = "10.0.1.0/24"

  tags {
    Name = "AWMAGSNET12"
    Resource_Group = "AWMAGRGVPC1"
  }
}

resource "aws_network_interface" "AWMAGNIC12" {
  subnet_id = "${aws_subnet.SNET12.id}"
  private_ips = ["10.0.1.4"]
  security_groups = ["${data.terraform_remote_state.localstate.security_group_name}"]

  tags {
    Name = "AZMAGNIC12"
    Resource_Group = "AWMAGRGFTPPRD"
  }
}

resource "aws_eip" "FTPPRDEIP" {
  instance = "${aws_instance.FTPPRDVM.id}"
  vpc      = true
  network_interface = "${aws_network_interface.AWMAGNIC12.id}"

  tags {
    Resource_Group = "AWMAGRGFTPPRD"
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

resource "aws_instance" "FTPPRDVM" {
  ami           = "${data.aws_ami.amazon_windows_2016.id}"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = "${aws_network_interface.AWMAGNIC12.id}"
    device_index = 0
    }

  tags {
    Resource_Group = "AWMAGRGFTPPRD"
  }
}
