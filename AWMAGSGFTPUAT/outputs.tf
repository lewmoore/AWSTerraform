output "vpc_name" {
  value = "${aws_vpc.VPC1.name}"
}

output "security_group_name" {
  value = "${aws_security_group.FTPUATSG.name}"
}
