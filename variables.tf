variable "client" {
  description = "The product owner"
  default = "Acme Corporation"
}

variable "project" {
  description = "Project to send the bill to"
  default = "Marketing"
}

variable "costcenter" {
  description = "Cost code to use in billing"
  default = "AM234"
}

variable "environment" {
  description = "Environment deployed - Dev or Prod"
  default = "Development"
}

variable "aws_region" {
  description = "Region for the VPC"
  default = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.10.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "10.10.2.0/24"
}

variable "ami" {
  description = "Ubuntu Server 18.04 LTS"
  default = "ami-00035f41c82244dab"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "/path/to/ssh/public/key.pub"
}
