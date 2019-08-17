//
variable "ami_name" {
  default = "devtools"
}
variable "ami_id" {
  default = "ami-0d73c05040ee827f7"
}
variable "ami_key_pair_name" {
  default = "testkp"
}
variable "access_key" {
  default = "AKIA5YEGRTHJZX4DQWNJ"
  }
variable "secret_key" {
  default = "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"
  }
  
variable "region" {
  default = "us-east-2"
  }

variable "private_key" {
  default = "~/awskey/testkp.pem"
}
variable "ansible_user" {
  default = "ubuntu"
  
}

