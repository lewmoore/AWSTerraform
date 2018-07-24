resource "aws_security_group" "FTPUATSG" {
  vpc_id = "${aws_vpc.VPC1.id}"

  ingress {
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["94.31.4.69/32"]
  }
  ingress {
    from_port   = 5000
    to_port     = 5050
    protocol    = "tcp"
    cidr_blocks = ["94.31.4.69/32"]
  }
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["94.31.4.69/32"]
  }

  tags {
    Resource_Group = "AWMAGRGFTPUAT"
  }
}
