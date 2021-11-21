resource "aws_instance" "nextcloud_app_instance" {
  ami               = var.aws_ami
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  # vpc_security_group_ids = [aws_security_group.nextcloud_app_sg.id]
  # subnet_id = var.outer_subnet_id

  key_name = "terraform-key"

  tags = {
    Name = "Nextcloud app"
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.outer_app_nic.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.inner_app_nic.id
  }

  user_data = "${data.template_cloudinit_config.cloudinit-nextcloud.rendered}"
}

resource "aws_security_group" "nextcloud_app_sg" {
  name = "nextcloud_app_sg"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_network_interface" "inner_app_nic" {
  subnet_id       = var.inner_subnet_id
  private_ips     = ["10.0.2.50"]
  security_groups = [aws_security_group.nextcloud_app_sg.id]
}

resource "aws_network_interface" "outer_app_nic" {
  subnet_id       = var.outer_subnet_id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.nextcloud_app_sg.id]
}

resource "aws_eip" "main" {
    vpc = true
    # instance = var.instance_id
    network_interface         = aws_network_interface.outer_app_nic.id
    associate_with_private_ip = "10.0.1.50"

    depends_on = [
        aws_network_interface.outer_app_nic
    ]

    tags = {
        Name = "Nextcloud Main EIP"
    }
}