output "public_ip" {
  value = module.nextcloud-app.eip_public_ip
}

output "public_dns" {
  value = module.nextcloud-app.eip_public_dns
}