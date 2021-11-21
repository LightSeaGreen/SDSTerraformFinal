resource "aws_eip" "nat_gateway" {
    vpc = true

    tags = {
        Name = "Nextcloud NAT EIP"
    }
}

