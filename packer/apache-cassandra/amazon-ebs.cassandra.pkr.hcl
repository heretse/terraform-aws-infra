locals {
  timestamp_sanitized = "${formatdate("YYYYMMDDhhmmss", timestamp())}"
}

source "amazon-ebs" "cassandra" {
  ami_description             = "amazon cassandra AMI"
  ami_name                    = "cassandra-BASE-v${var.BUILD_NUMBER}-${local.timestamp_sanitized}-AMI-arm64"
  ami_users                   = var.ami_users
  ami_virtualization_type     = "hvm"
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type
  region                      = var.region
  run_tags = {
    Name        = "amazon-cassandra-packer"
    Application = "cassandra"
  }
  spot_price    = "auto"
  ssh_username  = "ec2-user"
  ssh_interface = var.ssh_interface

  subnet_id = var.subnet_id

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "amzn2-ami-hvm-*-arm64-gp2"
      root-device-type    = "ebs"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  temporary_key_pair_name = "amazon-packer-${local.timestamp_sanitized}"

  vpc_id = var.vpc_id

  tags = {
    OS_Version  = "Amazon 2 linux"
    Version     = var.BUILD_NUMBER
    Application = "Cassandra Image"
    Runner      = "EC2"
  }
}
