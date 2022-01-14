# Create cloudfront distribution

resource "aws_cloudfront_distribution" "cloudfront-distribution" {
  enabled = var.distribution_enabled
  is_ipv6_enabled = var.distribution_ipv6_enabled
  comment = var.distribution_comment
  price_class = var.distribution_price_class
  default_root_object = var.distribution_default_root_object

  aliases = var.distribution_aliases

  default_cache_behavior {
    allowed_methods            = var.allowed_methods
    cached_methods             = var.cached_methods
    cache_policy_id            = var.cache_policy_id
    origin_request_policy_id   = var.origin_request_policy_id
    target_origin_id           = module.this.id
    compress                   = var.compress
    response_headers_policy_id = var.response_headers_policy_id

    dynamic "forwarded_values" {
      # If a cache policy or origin request policy is specified, we cannot include a `forwarded_values` block at all in the API request
      for_each = try(coalesce(var.cache_policy_id), null) == null && try(coalesce(var.origin_request_policy_id), null) == null ? [true] : []
      content {
        headers = var.forward_headers

        query_string = var.forward_query_string

        cookies {
          forward           = var.forward_cookies
          whitelisted_names = var.forward_cookies_whitelisted_names
        }
      }
    }


    viewer_protocol_policy = var.viewer_protocol_policy
    default_ttl            = var.default_ttl
    min_ttl                = var.min_ttl
    max_ttl                = var.max_ttl
  }

}