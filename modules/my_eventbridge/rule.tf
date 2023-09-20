locals {
  rules = yamldecode(file("${var.eventbridge_path}"))["rules"]
}

resource "aws_cloudwatch_event_rule" "rule" {
  for_each = { for r in local.rules : r.name => r }

  name           = each.value.name
  description    = each.value.description
  event_bus_name = each.value.event_bus_name
  event_pattern  = file("${each.value.event_pattern_file}")
  is_enabled     = each.value.enabled
}
