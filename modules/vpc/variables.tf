variable "instance_id" {
    description = "Instance id to assign the Elastic IP to"
}

variable "vpc_cidr" {
  description = "CIDR of the VPC"
}

variable "public_subnet_cidr" {
  description = "CIDR of the public subnet"
}

variable "private_inner_subnet_cidr" {
  description = "CIDR of the inner private subnet"
}

variable "private_outer_subnet_cidr" {
  description = "CIDR of the outer private subnet"
}

variable "availability_zone" {
  description = "availability_zone of all subnets"
  default = "ap-southeast-1a"
}
