data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

data "aws_ami" "bastion_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = var.bastion_ami["filter"]
  }

  owners = var.bastion_ami["owners"]
}
