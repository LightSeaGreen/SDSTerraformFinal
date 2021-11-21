# output "eip_public_ip" {
#   value = aws_eip.main.public_ip
# }

# output "eip_public_dns" {
#   value = aws_eip.main.public_dns
# }

output "vpc_id" {
  value = aws_vpc.nextcloud_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.nextcloud_app_subnet.id
}

output "private_inner_subnet_id" {
  value = aws_subnet.nextcloud_db_to_app_subnet.id
}

output "private_outer_subnet_id" {
  value = aws_subnet.nextcloud_db_to_rt_subnet.id
}

# output "subnet_group" {
#   value = aws_db_subnet_group.nextcloud_db_subnet_grp.id
# }