locals {
  bastion_allowed_ips = [
    "0.0.0.0/0"
  ]

  bastion_ami = {
    filter = ["amzn2-ami-hvm-*-x86_64-ebs"]
    owners = ["amazon"]
  }
}
