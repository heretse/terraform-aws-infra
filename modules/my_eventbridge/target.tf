locals {
  targets = yamldecode(file("${var.eventbridge_path}"))["targets"]
}

resource "aws_cloudwatch_event_target" "target" {
  for_each = { for r in local.targets : r.target_id => r }

  arn       = each.value.arn
  rule      = each.value.rule_name
  target_id = each.value.target_id

  depends_on = [
    aws_cloudwatch_event_rule.rule
  ]
}
