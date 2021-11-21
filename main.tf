provider "aws" {
    region = var.region
}

resource "aws_key_pair" "deployer" {
  key_name   = "terraform-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZElTFf6NEiOyJDUp9jlB0aF9oK5yCxXW++onSQqjJ2ty+yLbDpdIEPlngbfIGv9+WTziFgrgWUR1EmadQoXNc2LUXqgvm5/5KegFzUCdNPzujY3tISGA+GrK4yUCdEW4Q6xtWlnAzZdYQplDbPBYLwRVc6/BtgiXvwQPms0wxgjebsqwP/YwcAMwG1CqYOFjeHJgHeHtYrVY17nXMAZBlxcumMKR+XAYJzNDGUHV1kAp/mQTj5vFxIz+SROV4Mbb6iVea/gruwvDIAJNO3vu5QhVRjYt/80Tb+RtOKMNoDdkbf5SKS9uAXrw3VwHcoxDgddfHzoBqGFacjxglv0qJ terraform-key"
}

module "iam" {
  source = "./modules/iam"
}

module "network" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr
  public_subnet_cidr = var.nextcloud_cidr
  private_inner_subnet_cidr = var.db_nextcloud_cidr
  private_outer_subnet_cidr = var.db_rt_cidr
  availability_zone = var.availability_zone

  instance_id = module.nextcloud-app.nextcloud_core_instance_id
}

module "s3" {
  source = "./modules/services/s3"

  s3_bucket_name = var.bucket_name
  nextcloud_iam_user_arn = module.iam.nextcloud_iam_user_arn
  terraform_iam_user_arn = module.iam.terraform_iam_user_arn

  force_destroy = var.force_datastore_destroy
}

module "maria" {
  source = "./modules/services/maria"
  availability_zone = var.availability_zone
  instance_type = var.nextcloud_instance_type
  aws_ami = var.ami

  vpc_id = module.network.vpc_id
  inner_subnet_id = module.network.private_inner_subnet_id
  outer_subnet_id = module.network.private_outer_subnet_id

  db_name = var.database_name
  db_user = var.database_user
  db_pass = var.database_pass
}

module "nextcloud-app" {
  source = "./modules/services/nextcloud-app"
  availability_zone = var.availability_zone
  instance_type = var.nextcloud_instance_type
  aws_ami = var.ami

  vpc_id = module.network.vpc_id
  inner_subnet_id = module.network.private_inner_subnet_id
  outer_subnet_id = module.network.public_subnet_id

  db_name = var.database_name
  db_user = var.database_user
  db_pass = var.database_pass
  db_endpoint = "10.0.2.51"

  admin_user = var.admin_user
  admin_pass = var.admin_pass
  # data_dir = var.

  aws_region = var.region
  s3_bucket_name = var.bucket_name
  s3_access_key = module.iam.nextcloud_iam_user_access_key
  s3_secret_key = module.iam.nextcloud_iam_user_secret_key

  dep = module.maria.nonce
}