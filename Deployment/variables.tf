//
variable "ami_name" {
  default = "devtools"
}
variable "ami_id" {
  default = "ami-0d73c05040ee827f7"
}
variable "ami_key_pair_name" {
  default = "testkp1"
}
variable "profile" {
  default = "default"
  }
  
variable "region" {
  default = "us-east-2"
  }

variable "private_key" {
  default = "~/awskey/testkp1.pem"
}
variable "ansible_user" {
  default = "ubuntu"
  
}

