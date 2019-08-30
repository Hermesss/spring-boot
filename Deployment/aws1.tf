
provider "aws" {
    profile = "${var.profile}"
    shared_credentials_file = "~/.aws/credentials"
    region = "${var.region}"
}

//network.tf
resource "aws_vpc" "dev-env" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  
}
//resource "aws_eip" "ip-dev-env" {
 // instance = "${aws_instance.devtools.id}"
  //vpc      = true
//}
//gateways.tf
resource "aws_internet_gateway" "dev-env-gw" {
  vpc_id = "${aws_vpc.dev-env.id}"

}


//subnets.tf
resource "aws_subnet" "subnet-one" {
  cidr_block = "${cidrsubnet(aws_vpc.dev-env.cidr_block, 3, 1)}"
  vpc_id = "${aws_vpc.dev-env.id}"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-2a"
}

  resource "aws_route_table" "route-table-dev-env" {
  vpc_id = "${aws_vpc.dev-env.id}"
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.dev-env-gw.id}"
  }

}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.subnet-one.id}"
  route_table_id = "${aws_route_table.route-table-dev-env.id}"
}


//security.tf
resource "aws_security_group" "ingress-all-test" {
name = "allow-all-sg"
vpc_id = "${aws_vpc.dev-env.id}"
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }
// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

//servers.tf
resource "aws_instance" "devtools" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = "${var.ami_key_pair_name}"
  security_groups = ["${aws_security_group.ingress-all-test.id}"]
  subnet_id = "${aws_subnet.subnet-one.id}"
  provisioner "remote-exec" {
    inline = ["sudo apt-get -qq install python -y"]
  }
  
  connection {
    host = "${aws_instance.devtools.public_ip}"
    private_key = "${file(var.private_key)}"
    user        = "ubuntu"
  }  
  tags = {
    Name = "devtools"
  }
}
  /*provisioner "local-exec" {
    command = <<EOT
      sleep 60;
      >/tmp/devtools.ini;
      echo "[devtools]" | tee -a /tmp/devtools.ini;
      echo "${aws_instance.devtools.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.private_key}" | tee -a /tmp/devtools.ini;
    EOT
  }
  */
resource "aws_instance" "artifactory" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = "${var.ami_key_pair_name}"
  security_groups = ["${aws_security_group.ingress-all-test.id}"]
  subnet_id = "${aws_subnet.subnet-one.id}"

  tags = {
    Name = "arifactory"
  }

}
resource "aws_instance" "qa" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = "${var.ami_key_pair_name}"
  security_groups = ["${aws_security_group.ingress-all-test.id}"]
  subnet_id = "${aws_subnet.subnet-one.id}"

  tags = {
    Name = "qa"
  }

}
resource "aws_instance" "ci" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = "${var.ami_key_pair_name}"
  security_groups = ["${aws_security_group.ingress-all-test.id}"]
  subnet_id = "${aws_subnet.subnet-one.id}"
  
  tags = {
    Name = "ci"
  }
}

//output
output "devtools" {
  value = "${aws_instance.devtools.public_ip}"
}
output "qa" {
  value = "${aws_instance.qa.public_ip}"
}
output "ci" {
  value = "${aws_instance.ci.public_ip}"
}
output "artifactory" {
  value = "${aws_instance.artifactory.public_ip}"
} 
