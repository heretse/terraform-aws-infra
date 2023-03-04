

resource "aws_subnet" "subnets" {
  for_each = { for r in local.subnets : r.name => r }

  assign_ipv6_address_on_creation = lookup(each.value, "assign_ipv6_address_on_creation", false)
  availability_zone               = each.value.zone
  cidr_block                      = each.value.cidr
  ipv6_cidr_block                 = lookup(each.value, "ipv6_cidr", null)
  customer_owned_ipv4_pool        = ""
  map_customer_owned_ip_on_launch = false
  map_public_ip_on_launch         = lookup(each.value, "map_public_ip_on_launch", false)
  outpost_arn                     = ""

  tags = {
    Department                        = var.department_name
    Env                               = var.environment
    Name                              = each.value.name
    Project                           = lookup(each.value, "project", var.project_name)
    "kubernetes.io/role/elb"          = lookup(each.value, "k8s_elb", false) ? "1" : null
    "kubernetes.io/role/internal-elb" = lookup(each.value, "k8s_internal_elb", false) ? "1" : null
    "karpenter.sh/discovery"          = lookup(each.value, "karpenter_discovery", null)
  }

  tags_all = {
    Department                        = var.department_name
    Env                               = var.environment
    Name                              = each.value.name
    Project                           = var.project_name
    "kubernetes.io/role/elb"          = lookup(each.value, "k8s_elb", false) ? "1" : null
    "kubernetes.io/role/internal-elb" = lookup(each.value, "karpenter_discovery", null)
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.vpc_id
  ]
}
