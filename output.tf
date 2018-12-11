output "Public_Instance_DNS" {
  value = "${aws_instance.wordpress-instance.public_dns}"
}
output "Public_Instance_IP" {
  value = "${aws_instance.wordpress-instance.public_ip}"
}
output "Private_Instance_IP" {
  value = "${aws_instance.database-instance.private_ip}"
}
