locals {
  distributions = yamldecode(file("${var.distribution_path}"))["distributions"]
}

resource "aws_cloudfront_distribution" "distributions" {
  # checkov:skip=CKV2_AWS_47: need to do it later

  for_each = { for r in local.distributions : r.name => r }

  aliases = each.value.aliases

  dynamic "custom_error_response" {

    for_each = lookup(each.value, "custom_error_response", [])

    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  default_cache_behavior {
    allowed_methods            = ["GET", "HEAD"]
    cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods             = ["GET", "HEAD"]
    compress                   = "true"
    default_ttl                = "0"
    max_ttl                    = "0"
    min_ttl                    = "0"
    smooth_streaming           = "false"
    target_origin_id           = "S3-${format("%s%s", each.value.bucket_name, each.value.origin_path)}"
    viewer_protocol_policy     = "redirect-to-https"
    response_headers_policy_id = (each.value.response_headers_policy != "") ? aws_cloudfront_response_headers_policy.policies["${each.value.response_headers_policy}"].id : null

    dynamic "lambda_function_association" {
      for_each = lookup(each.value, "lambda_function_association", null) == null ? [] : [1]
      content {
        event_type   = each.value.lambda_function_association.event_type
        include_body = each.value.lambda_function_association.include_body
        lambda_arn   = each.value.lambda_function_association.lambda_arn
      }
    }
  }

  enabled         = "true"
  http_version    = "http2"
  is_ipv6_enabled = "true"

  dynamic "logging_config" {
    for_each = each.value.logging_bucket == "" ? [] : [1]
    content {
      bucket          = "${each.value.logging_bucket}.s3.amazonaws.com"
      include_cookies = "false"
      prefix          = each.value.logging_prefix
    }
  }

  origin {
    connection_attempts = "3"
    connection_timeout  = "10"
    domain_name         = "${each.value.bucket_name}.s3.amazonaws.com"
    origin_id           = "S3-${format("%s%s", each.value.bucket_name, each.value.origin_path)}"
    origin_path         = each.value.origin_path != "" ? each.value.origin_path : null

    s3_origin_config {
      origin_access_identity = var.access_identity_path
    }
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  tags = {
    Department = each.value.department
    Env        = var.environment
    Name       = "${format("%s%s", each.value.bucket_name, each.value.origin_path)}-cf"
    Project    = each.value.project
  }

  tags_all = {
    Department = each.value.department
    Env        = var.environment
    Name       = "${format("%s%s", each.value.bucket_name, each.value.origin_path)}-cf"
    Project    = each.value.project
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  depends_on = [
    aws_cloudfront_response_headers_policy.policies,
    var.s3_buckets
  ]
}
