output "aws_vpc" {
  value = "${aws_vpc.VPC1.id}"
}

output "security_group_name" {
  value = "${aws_security_group.FTPUATSG.id}"
}
