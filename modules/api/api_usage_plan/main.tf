resource "aws_api_gateway_usage_plan" "dasher_plan" {
  name         = "${var.ENV}_dasher_plan"
  description  = "Describes APIs only dashers can access"
  product_code = "DASHER"

  api_stages {
    api_id = var.DASHER_API_ID
    stage  = var.ENV
  }

  quota_settings {
    limit  = 20
    offset = 2
    period = "WEEK"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }
}

resource "aws_api_gateway_usage_plan" "user_plan" {
  name         = "${var.ENV}_user_plan"
  description  = "Describes APIs only users can access"
  product_code = "USER"

  api_stages {
    api_id = var.USER_API_ID
    stage  = var.ENV
  }

  quota_settings {
    limit  = 20
    offset = 2
    period = "WEEK"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }
}

resource "aws_api_gateway_usage_plan" "vendor_plan" {
  name         = "${var.ENV}_vendor_plan"
  description  = "Describes APIs only vendors can access"
  product_code = "VENDOR"

  api_stages {
    api_id = var.VENDOR_API_ID
    stage  = var.ENV
  }

  quota_settings {
    limit  = 20
    offset = 2
    period = "WEEK"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }
}

