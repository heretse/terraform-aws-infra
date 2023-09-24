resource "aws_security_group" "cassandra" {
  name        = "Cassandra"
  description = "Cassandra security group managed by Terraform"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "For SSH access"
    cidr_blocks = var.ssh-inbound-range
  }

  ingress {
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    description = "CSQLSH port"
    cidr_blocks = var.allowed_ranges
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    description = "node-exporter 9100 port"
    cidr_blocks = var.allowed_ranges
  }

  ingress {
    from_port   = 9160
    to_port     = 9160
    protocol    = "tcp"
    description = "Cassandra Thrift port"
    cidr_blocks = var.allowed_ranges
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    description = "allow traffic for TCP 8080 (cassandra-exporter)"
    cidr_blocks = var.allowed_ranges
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    description = "allows traffic from the SG itself for TCP"
    self        = true
  }

  ingress {
    from_port   = 7199
    to_port     = 7199
    protocol    = "tcp"
    description = "allow traffic for TCP 7199 (JMX)"
    cidr_blocks = var.allowed_ranges
  }

  ingress {
    from_port   = 7000
    to_port     = 7000
    protocol    = "tcp"
    description = "7000 Inter-node cluster"
    cidr_blocks = var.allowed_ranges
  }

  ingress {
    from_port   = 7001
    to_port     = 7001
    protocol    = "tcp"
    description = "Inter-node cluster SSL"
    cidr_blocks = var.allowed_ranges
  }

  ingress {
    from_port   = 9500
    to_port     = 9500
    protocol    = "tcp"
    description = "allow traffic for TCP 9500 (cassandra-exporter-standalone)"
    cidr_blocks = var.allowed_ranges
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "Allow outbound"
    # tfsec:ignore:AWS009
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "Cassandra-SG"
  }

  vpc_id = var.vpc_id
}
