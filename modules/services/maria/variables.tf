variable "instance_type" {
    default = "t2.micro"
}

variable "aws_region"{
    default = "ap-southeast-1"
}
variable "availability_zone"{
    default = "ap-southeast-1a"
}

variable "inner_subnet_id" {
    description = "Subnet to place this instance (inner)"
}
variable "outer_subnet_id" {
    description = "Subnet to place this instance (outer)"
}

variable "vpc_id" {
    description = "Vpc id to assign to this instance"
}

variable "aws_ami" {
    description = "Ubuntu AMI"
}


### DB

variable "db_name" {
  description = "Database name"
  default = "nextcloud_db"
}

variable "db_user" {
  description = "Database user"
}

variable "db_pass" {
  description = "Database password"
}