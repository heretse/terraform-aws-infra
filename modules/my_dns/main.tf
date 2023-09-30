resource "aws_route53_zone" "r53zone" {
  # checkov:skip=CKV2_AWS_38: "Ensure Domain Name System Security Extensions (DNSSEC) signing is enabled for Amazon Route 53 public hosted zones"
  # checkov:skip=CKV2_AWS_39: "Ensure Domain Name System (DNS) query logging is enabled for Amazon Route 53 hosted zones"

  name = var.domain_name

  dynamic "vpc" {
    for_each = local.vpcs
    content {
      vpc_id     = vpc.value["vpc_id"]
      vpc_region = vpc.value["vpc_region"]
    }
  }

  tags = { for tag in local.tags : tag.key => tag.value }
}

locals {
  record_simple = yamldecode(file("${var.record_path}"))["simple"]
  record_alias  = yamldecode(file("${var.record_path}"))["alias"]
  vpcs          = yamldecode(file("${var.record_path}"))["vpcs"]
  tags          = yamldecode(file("${var.record_path}"))["tags"]
}

resource "aws_route53_record" "simples" {

  for_each = { for r in local.record_simple : r.name => r }

  zone_id = aws_route53_zone.r53zone.id
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records
}

resource "aws_route53_record" "aliases" {

  for_each = { for r in local.record_alias : r.name => r }

  zone_id = aws_route53_zone.r53zone.id
  name    = each.value.name
  type    = each.value.type

  alias {
    name                   = each.value.alias_target.dns_name
    zone_id                = each.value.alias_target.hosted_zone_id
    evaluate_target_health = each.value.alias_target.evaluate_target_health
  }
}
