
# --------------- COGNITO APP CLIENTS ---------------
# Create app client for dashers user pool
resource "aws_cognito_user_pool_client" "dasher_client" {
  name = "${var.ENV}_dasher_client"
  user_pool_id = var.DASHER_USERPOOL_ID

  generate_secret     = false
  explicit_auth_flows = ["USER_PASSWORD_AUTH"]

}

# Create app client for users user pool
resource "aws_cognito_user_pool_client" "user_client" {
  name = "${var.ENV}_user_client"
  user_pool_id = var.USER_USERPOOL_ID

  generate_secret     = false
  explicit_auth_flows = ["USER_PASSWORD_AUTH"]

}

# Create app client for users user pool
resource "aws_cognito_user_pool_client" "vendor_client" {
  name = "${var.ENV}_vendor_client"
  user_pool_id = var.VENDOR_USERPOOL_ID

  generate_secret     = false
  explicit_auth_flows = ["USER_PASSWORD_AUTH"]

}
