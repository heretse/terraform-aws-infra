locals {
  bastion_allowed_ips = [
    "0.0.0.0/0"
  ]

  bastion_ami = {
    filter = ["amzn2-ami-hvm-*-x86_64-ebs"]
    owners = ["amazon"]
  }

  cassandra_ami = {
    filter = ["cassandra-BASE-v*-AMI-arm64"]
    owners = [data.aws_caller_identity.current.account_id]
  }

  cassandra_private_ips = [
    cidrhost("10.4.16.0/24", 248),
    cidrhost("10.4.17.0/24", 248),
    cidrhost("10.4.18.0/24", 248)
  ]
}
