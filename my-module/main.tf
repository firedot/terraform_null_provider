variable "ami_id" {}
variable "instance_type" {}

resource "aws_instance" "db" {
  ami        = "${var.ami_id}"
  instance_type = "${var.instance_type}"
}

output "public_ip" {
  value = "${aws_instance.db.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.db.public_dns}"
}
