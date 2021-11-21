output "nextcloud_core_instance_id" {
    value = aws_instance.nextcloud_app_instance.id
}

output "eip_public_ip" {
  value = aws_eip.main.public_ip
}

output "eip_public_dns" {
  value = aws_eip.main.public_dns
}