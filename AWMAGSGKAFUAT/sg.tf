resource "aws_security_group" "kafuatsg" {
  name = "KAFUATSG"
  vpc_id = "${aws_vpc.vpc2.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["94.31.4.69/32"]
  }

  ingress {
    from_port = 8000
    to_port = 8030
    protocol = "tcp"
    cidr_blocks = ["94.31.4.69/32"]
  }
}
