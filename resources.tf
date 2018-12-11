# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name = "defaultsshkeypair"
  public_key = "${file("${var.key_path}")}"
}

# Define EC2 instance inside the public subnet
resource "aws_instance" "wordpress-instance" {
   ami  = "${var.ami}"
   instance_type = "t2.nano"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.frontendsg.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   user_data = "${file("frontinstall.sh")}"

  tags {
    Name = "wp-webserver"
    Client = "${var.client}"
    Project = "${var.project}"
  }

}
# Define EC2 instance inside the private subnet
resource "aws_instance" "database-instance" {
   ami  = "${var.ami}"
   instance_type = "t2.nano"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.private-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.backendsg.id}"]
   associate_public_ip_address = false
   source_dest_check = false
   user_data = "${file("backendinstall.sh")}"

  tags {
    Name = "wp-dbserver"
    Client = "${var.client}"
    Project = "${var.project}"
  }
}
