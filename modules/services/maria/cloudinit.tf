data "template_cloudinit_config" "cloudinit-maria" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/scripts/1.sh", {
        database_name = var.db_name,
        database_user = var.db_user,
        db_root_password = var.db_pass
    })
  }
}