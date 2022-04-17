resource "aws_dynamodb_table" "table" {
  name           = "${var.ENV}_${var.RESOURCE_PREFIX}_table"
  billing_mode   = var.billing_mode
  hash_key       = "email"

  attribute {
    name = "email"
    type = "S"
  }

  tags = var.TAGS
}