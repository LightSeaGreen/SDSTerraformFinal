resource "aws_instance" "maria_instance" {
  ami               = var.aws_ami
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  # vpc_security_group_ids = [aws_security_group.maria_sg.id]
  # subnet_id = var.outer_subnet_id

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.outer_app_nic.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.inner_app_nic.id
  }

  key_name = "terraform-key"

  tags = {
    Name = "Nextcloud maria"
  }

  user_data = data.template_cloudinit_config.cloudinit-maria.rendered
}

resource "aws_security_group" "maria_sg" {
  name   = "nextcloud_maria_sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "Nextcloud maria sg"
  }

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.50/32"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_network_interface" "inner_app_nic" {
  subnet_id       = var.inner_subnet_id
  private_ips     = ["10.0.2.51"]
  security_groups = [aws_security_group.maria_sg.id]
}

resource "aws_network_interface" "outer_app_nic" {
  subnet_id       = var.outer_subnet_id
  private_ips     = ["10.0.3.50"]
  security_groups = [aws_security_group.maria_sg.id]
}
