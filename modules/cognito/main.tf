
# --------------- COGNITO USER POOLS ---------------
# Dashers pool
resource "aws_cognito_user_pool" "dasher_userpool" {
    name = "${var.ENV}_dasher_userpool"
    auto_verified_attributes = ["email"]

    email_configuration {
      email_sending_account = "COGNITO_DEFAULT"
    }

    account_recovery_setting {
      recovery_mechanism {
          name     = "verified_email"
          priority = 1
      }

      recovery_mechanism {
          name     = "verified_phone_number"
          priority = 2
      }
    }

    password_policy {
      minimum_length = 6
      require_symbols = false
      temporary_password_validity_days = 7
    }

    schema {
      name                     = "given_name"
      required                 = true
      attribute_data_type      = "String"
      string_attribute_constraints {
          min_length = 0
          max_length = 2048
      }
    }
}

# Users pool
resource "aws_cognito_user_pool" "user_userpool" {
    name = "${var.ENV}_user_userpool"
    auto_verified_attributes = ["email"]

    account_recovery_setting {
        recovery_mechanism {
            name     = "verified_email"
            priority = 1
        }

        recovery_mechanism {
            name     = "verified_phone_number"
            priority = 2
        }
    }

    password_policy {
        minimum_length = 6
        require_symbols = false
        temporary_password_validity_days = 7
    }

    schema {
        name                     = "given_name"
        required                 = true
        attribute_data_type      = "String"
        string_attribute_constraints {
            min_length = 0
            max_length = 2048
        }
    }
}

# Vendors pool
resource "aws_cognito_user_pool" "vendor_userpool" {
    name = "${var.ENV}_vendor_userpool"
    auto_verified_attributes = ["email"]

    account_recovery_setting {
        recovery_mechanism {
            name     = "verified_email"
            priority = 1
        }

        recovery_mechanism {
            name     = "verified_phone_number"
            priority = 2
        }
    }

    password_policy {
        minimum_length = 6
        require_symbols = false
        temporary_password_validity_days = 7
    }

    schema {
        name                     = "given_name"
        required                 = true
        attribute_data_type      = "String"
        string_attribute_constraints {
            min_length = 0
            max_length = 2048
        }
    }
}
