variable "access_key" {}

variable "secret_key" {}

variable "region" {
  default = "us-east-2"
}

module "my-module" {
  #source can be any URL of file_path
  source        = "./my-module/"
  ami_id        = "ami-941a1ff1"
  instance_type = "t2.micro"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "cluster" {
  count         = 4
  ami           = "ami-941a1ff1"
  instance_type = "t2.micro"

  subnet_id              = "subnet-f090b498"
  vpc_security_group_ids = ["sg-0104bd2e830bc7973"]

  tags {
    "Identity" = "test-web-srv"
    "Name"     = "test"
  }
}

resource "null_resource" "cluster" {
  triggers = {
    cluster_instance_ids = "${join(",", aws_instance.cluster.*.id)}"
  }
}


output "public_ip" {
  value = "${aws_instance.cluster.*.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.cluster.*.public_dns}"
}

output "address_from_module" {
  value = "${module.my-module.public_ip}"
}

output "dns_from_module" {
  value = "${module.my-module.public_dns}"
}
