terraform {
  required_providers {
    aws = {
      version = "4.62.0"
    }
  }

  backend "s3" {
    bucket                  = "my-terraform-infra"
    dynamodb_table          = "my-terraform-infra-locks"
    key                     = "terraform.tfstate"
    region                  = "ap-northeast-1"
    shared_credentials_file = "~/.aws/config"
    profile                 = "heretse"
  }
}

# vpc
module "vpc" {
  aws_profile     = var.aws_profile
  aws_region      = var.aws_region
  department_name = var.department_name
  project_name    = var.project_name
  vpc_path        = "./configs/vpc/vpc.yaml"

  source = "./modules/my_vpc"
}

# subnet
module "subnet" {
  aws_profile     = var.aws_profile
  aws_region      = var.aws_region
  department_name = var.department_name
  project_name    = var.project_name
  vpc_id          = module.vpc.vpc_name["my-vpc"].id
  vpc_cidr        = module.vpc.vpc_name["my-vpc"].cidr_block
  subnet_path     = "./configs/subnet/my-subnets.yaml"

  source = "./modules/my_subnets"
}

module "igw" {
  aws_profile     = var.aws_profile
  aws_region      = var.aws_region
  department_name = var.department_name
  project_name    = var.project_name
  vpc_id          = module.vpc.vpc_name["my-vpc"].id

  source = "./modules/my_igw"
}

# nacl
module "nacl" {
  # checkov:skip=CKV_AWS_230: check it later
  # checkov:skip=CKV_AWS_229: check it later
  # checkov:skip=CKV_AWS_232: check it later
  # checkov:skip=CKV_AWS_231: check it later
  aws_profile             = var.aws_profile
  aws_region              = var.aws_region
  department_name         = var.department_name
  project_name            = var.project_name
  vpc_cidr                = module.vpc.vpc_name["my-vpc"].cidr_block
  vpc_id                  = module.vpc.vpc_name["my-vpc"].id
  subnet_public_a_id      = module.subnet.subnets["my-public-ap-northeast-1a"].id
  subnet_public_c_id      = module.subnet.subnets["my-public-ap-northeast-1c"].id
  subnet_public_d_id      = module.subnet.subnets["my-public-ap-northeast-1d"].id
  subnet_application_a_id = module.subnet.subnets["my-application-ap-northeast-1a"].id
  subnet_application_c_id = module.subnet.subnets["my-application-ap-northeast-1c"].id
  subnet_application_d_id = module.subnet.subnets["my-application-ap-northeast-1d"].id
  subnet_intra_a_id       = module.subnet.subnets["my-intra-ap-northeast-1a"].id
  subnet_intra_c_id       = module.subnet.subnets["my-intra-ap-northeast-1c"].id
  subnet_intra_d_id       = module.subnet.subnets["my-intra-ap-northeast-1d"].id
  subnet_persistence_a_id = module.subnet.subnets["my-persistence-ap-northeast-1a"].id
  subnet_persistence_c_id = module.subnet.subnets["my-persistence-ap-northeast-1c"].id
  subnet_persistence_d_id = module.subnet.subnets["my-persistence-ap-northeast-1d"].id
  subnet_nat_server_id    = module.subnet.subnets["my-nat-server"].id

  source = "./modules/my_nacls"
}

resource "aws_security_group" "nxd_bastion_sg" {
  description = "Used for bastion instance public"

  ingress {
    cidr_blocks = local.bastion_allowed_ips
    description = "ssh from allowed ips"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  name = "bastion-sg"

  tags = {
    Department = var.department_name
    Name       = "Bastion-SG"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "Bastion-SG"
    Project    = var.project_name
  }

  vpc_id = module.vpc.vpc_name["my-vpc"].id
}

resource "aws_security_group" "nxd_nat_server_sg" {
  description = "Used for NAT instance public"

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = "0"
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "-1"
    self             = "false"
    to_port          = "0"
  }

  ingress {
    cidr_blocks = [module.vpc.vpc_name["my-vpc"].cidr_block]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  name = "nat-server-sg"

  tags = {
    Department = var.department_name
    Name       = "NAT-Server-SG"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "NAT-Server-SG"
    Project    = var.project_name
  }

  vpc_id = module.vpc.vpc_name["my-vpc"].id
}

# instances
module "instances" {
  # checkov:skip=CKV_AWS_8: check it later
  # checkov:skip=CKV_AWS_135:do it later
  # checkov:skip=CKV_AWS_79:do it later
  # checkov:skip=CKV_AWS_126:don't enable detail monitor in sandbox env

  aws_profile                   = var.aws_profile
  aws_region                    = var.aws_region
  department_name               = var.department_name
  project_name                  = var.project_name
  instance_type                 = "t3a.small"
  subnet_bastion_id             = module.subnet.subnets["my-public-ap-northeast-1d"].id
  subnet_nat_server_id          = module.subnet.subnets["my-nat-server"].id
  bastion_security_group_ids    = [aws_security_group.nxd_bastion_sg.id]
  nat_server_security_group_ids = [aws_security_group.nxd_nat_server_sg.id]
  ssh_key_name                  = var.ssh_key_name
  bastion_ami                   = local.bastion_ami
  bastion_ami_id                = null
  nat_server_ami_id             = null
  create_nat_server_instance    = true
  bastion_launch_template       = null
  bastion_user_data             = <<HERE
#!/bin/bash

echo "Do something you want here."

HERE

  source = "./modules/my_instances"
}

# elastic ip
module "eip" {
  aws_profile            = var.aws_profile
  aws_region             = var.aws_region
  department_name        = var.department_name
  project_name           = var.project_name
  bastion_instance_id    = module.instances.bastion_instance_id
  nat_server_instance_id = module.instances.nat_server_instance_id

  source = "./modules/my_eips"
}

# route table
module "rtb" {
  aws_profile     = var.aws_profile
  aws_region      = var.aws_region
  department_name = var.department_name
  project_name    = var.project_name
  vpc_id          = module.vpc.vpc_name["my-vpc"].id

  public_subnet_ids = [
    module.subnet.subnets["my-public-ap-northeast-1a"].id,
    module.subnet.subnets["my-public-ap-northeast-1c"].id,
    module.subnet.subnets["my-public-ap-northeast-1d"].id
  ]

  application_subnet_ids = [
    module.subnet.subnets["my-application-ap-northeast-1a"].id,
    module.subnet.subnets["my-application-ap-northeast-1c"].id,
    module.subnet.subnets["my-application-ap-northeast-1d"].id
  ]

  intra_subnet_ids = [
    module.subnet.subnets["my-intra-ap-northeast-1a"].id,
    module.subnet.subnets["my-intra-ap-northeast-1c"].id,
    module.subnet.subnets["my-intra-ap-northeast-1d"].id
  ]

  persistence_subnet_ids = [
    module.subnet.subnets["my-persistence-ap-northeast-1a"].id,
    module.subnet.subnets["my-persistence-ap-northeast-1c"].id,
    module.subnet.subnets["my-persistence-ap-northeast-1d"].id
  ]

  nat_server_subnet_ids = [
    module.subnet.subnets["my-nat-server"].id
  ]

  public_routes = [
    {
      cidr_block = "0.0.0.0/0",
      gateway_id = module.igw.igw_id
    },
    {
      gateway_id      = module.igw.igw_id,
      ipv6_cidr_block = "::/0"
    }
  ]

  application_routes = [
    {
      cidr_block           = "0.0.0.0/0",
      network_interface_id = module.eip.nat_server_eip_assoc_eni_id
    }
  ]

  intra_routes = [
    {
      cidr_block           = "0.0.0.0/0",
      network_interface_id = module.eip.nat_server_eip_assoc_eni_id
    }
  ]

  persistence_routes = [
    {
      cidr_block           = "0.0.0.0/0",
      network_interface_id = module.eip.nat_server_eip_assoc_eni_id
    }
  ]

  nat_server_routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.igw.igw_id
    }
  ]

  source = "./modules/my_route_tables"
}
