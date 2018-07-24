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
