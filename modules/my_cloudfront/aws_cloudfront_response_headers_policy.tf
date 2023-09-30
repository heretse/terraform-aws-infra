locals {
  response_headers_policies = yamldecode(file("${var.distribution_path}"))["response_headers_policies"]
}

resource "aws_cloudfront_response_headers_policy" "policies" {
  # checkov:skip=CKV_AWS_259: "Ensure CloudFront response header policy enforces Strict Transport Security"

  for_each = { for r in local.response_headers_policies : r.name => r }

  name = each.value.name

  dynamic "custom_headers_config" {
    for_each = lookup(each.value, "custom_headers_configs", null) != null ? [1] : []

    content {
      dynamic "items" {
        for_each = each.value.custom_headers_configs

        content {
          header   = items.value["header"]
          override = items.value["override"]
          value    = items.value["value"]
        }
      }
    }
  }

  dynamic "security_headers_config" {
    for_each = lookup(each.value, "security_headers_config", null) != null ? [each.value.security_headers_config] : []

    content {
      dynamic "content_security_policy" {
        for_each = lookup(security_headers_config.value, "content_security_policy", null) != null ? [security_headers_config.value["content_security_policy"]] : []

        content {
          content_security_policy = content_security_policy.value["content_security_policy"]
          override                = content_security_policy.value["override"]
        }
      }

      dynamic "content_type_options" {
        for_each = lookup(security_headers_config.value, "content_type_options", null) != null ? [security_headers_config.value["content_type_options"]] : []

        content {
          override = content_type_options.value["override"]
        }
      }

      dynamic "frame_options" {
        for_each = lookup(security_headers_config.value, "frame_options", null) != null ? [security_headers_config.value["frame_options"]] : []

        content {
          frame_option = frame_options.value["frame_option"]
          override     = frame_options.value["override"]
        }
      }

      dynamic "referrer_policy" {
        for_each = lookup(security_headers_config.value, "referrer_policy", null) != null ? [security_headers_config.value["referrer_policy"]] : []

        content {
          override        = referrer_policy.value["override"]
          referrer_policy = referrer_policy.value["referrer_policy"]
        }
      }

      dynamic "strict_transport_security" {
        for_each = lookup(security_headers_config.value, "strict_transport_security", null) != null ? [security_headers_config.value["strict_transport_security"]] : []

        content {
          access_control_max_age_sec = strict_transport_security.value["access_control_max_age_sec"]
          include_subdomains         = strict_transport_security.value["include_subdomains"]
          override                   = strict_transport_security.value["override"]
          preload                    = strict_transport_security.value["preload"]
        }
      }
    }
  }
}
