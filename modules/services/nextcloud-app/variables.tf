variable "dep" {}

variable "instance_type" {
    default = "t2.micro"
}

variable "availability_zone"{
    default = "ap-southeast-1a"
}

variable "outer_subnet_id" {
    description = "Subnet to place this instance"
}
variable "inner_subnet_id" {
    description = "Subnet to place this instance"
}

variable "vpc_id" {
    description = "Vpc id to assign to this instance"
}

# variable "key_name" {
#     description = "SSH Key name to associate to this instance"
# }

variable "aws_ami" {
    description = "Ubuntu AMI"
}

# RDS
variable "db_name" {
    description = "db_name"
}
variable "db_user" {
    description = "db_user"
}
variable "db_pass" {
    description = "db_pass"
}
variable "db_endpoint" {
    description = "db_endpoint"
}

variable "admin_user" {
    description = "admin_user"
}
variable "admin_pass" {
    description = "admin_pass"
}
variable "data_dir" {
    description = "data_dir"
    default = "/var/www/nextcloud/data"
}


# S3
variable "aws_region"{
    default = "ap-southeast-1"
}
variable "s3_bucket_name" {
    description = "s3_bucket_name"
}
variable "s3_access_key" {
    description = "s3_access_key"
}
variable "s3_secret_key" {
    description = "s3_secret_key"
}

