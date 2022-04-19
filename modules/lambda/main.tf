locals {
    python_version = "python3.8"
}

# =================================== LAYERS ==================================================
resource "aws_lambda_layer_version" "jsonschema" {
  filename   = "${path.module}/layers/jsonschema.zip"
  layer_name = "jsonschema"

  compatible_runtimes = [local.python_version]
  source_code_hash = "${filebase64sha256("${path.module}/layers/jsonschema.zip")}"
}


# ======================================= OPEN ==============================================
resource "aws_lambda_function" "signup_lambda" {
    filename      = data.archive_file.create_dist_pkg["signup"].output_path
    function_name = "${var.ENV}_signup"
    role          = var.SIGNUP_ROLE_ARN
    handler       = "signup.lambda_handler"
    layers        = [aws_lambda_layer_version.jsonschema.arn]
    timeout = 10

    source_code_hash = data.archive_file.create_dist_pkg["signup"].output_base64sha256
    runtime = local.python_version

    depends_on = [
        data.archive_file.create_dist_pkg["signup"],
        aws_lambda_layer_version.jsonschema
    ]

    environment {
        variables = {
            DASHER_CLIENT_ID = "${var.DASHER_CLIENT_ID}"
            USER_CLIENT_ID = "${var.USER_CLIENT_ID}"
            VENDOR_CLIENT_ID = "${var.VENDOR_CLIENT_ID}"

            DASHER_TABLE_NAME = var.DASHER_TABLE_NAME
            USER_TABLE_NAME = var.USER_TABLE_NAME
            VENDOR_TABLE_NAME = var.VENDOR_TABLE_NAME

            DASHER_USAGE_PLAN = "${var.DASHER_USAGE_PLAN}"
            USER_USAGE_PLAN = "${var.USER_USAGE_PLAN}"
            VENDOR_USAGE_PLAN = "${var.VENDOR_USAGE_PLAN}"
        }
    }
}

resource "aws_lambda_function" "confirm_signup_lambda" {
    filename      = data.archive_file.create_dist_pkg["confirm_signup"].output_path
    function_name = "${var.ENV}_confirm_signup"
    role          = var.CONFIRM_SIGNUP_ROLE_ARN
    handler       = "confirm_signup.lambda_handler"

    source_code_hash = data.archive_file.create_dist_pkg["confirm_signup"].output_base64sha256
    runtime = local.python_version

    depends_on = [
        data.archive_file.create_dist_pkg["confirm_signup"]
    ]

    environment {
        variables = {
            DASHER_CLIENT_ID = "${var.DASHER_CLIENT_ID}"
            USER_CLIENT_ID = "${var.USER_CLIENT_ID}"
            VENDOR_CLIENT_ID = "${var.VENDOR_CLIENT_ID}"
        }
    }
}

resource "aws_lambda_function" "resend_confirmation_code_lambda" {
    filename      = data.archive_file.create_dist_pkg["resend_confirmation_code"].output_path
    function_name = "${var.ENV}_resend_confirmation_code"
    role          = var.RESEND_CONFIRMATION_CODE_ROLE_ARN
    handler       = "resend_confirmation_code.lambda_handler"

    source_code_hash = data.archive_file.create_dist_pkg["resend_confirmation_code"].output_base64sha256
    runtime = local.python_version

    depends_on = [
        data.archive_file.create_dist_pkg["resend_confirmation_code"]
    ]

    environment {
        variables = {
            DASHER_CLIENT_ID = "${var.DASHER_CLIENT_ID}"
            USER_CLIENT_ID = "${var.USER_CLIENT_ID}"
            VENDOR_CLIENT_ID = "${var.VENDOR_CLIENT_ID}"
        }
    }
}

resource "aws_lambda_function" "signin_lambda" {
    filename      = data.archive_file.create_dist_pkg["signin"].output_path
    function_name = "${var.ENV}_signin"
    role          = var.SIGNIN_ROLE_ARN
    handler       = "signin.lambda_handler"

    source_code_hash = data.archive_file.create_dist_pkg["signin"].output_base64sha256
    runtime = local.python_version

    depends_on = [
        data.archive_file.create_dist_pkg["signin"]
    ]

    environment {
        variables = {
            DASHER_CLIENT_ID = "${var.DASHER_CLIENT_ID}"
            USER_CLIENT_ID = "${var.USER_CLIENT_ID}"
            VENDOR_CLIENT_ID = "${var.VENDOR_CLIENT_ID}"

            DASHER_TABLE_NAME = var.DASHER_TABLE_NAME
            USER_TABLE_NAME = var.USER_TABLE_NAME
            VENDOR_TABLE_NAME = var.VENDOR_TABLE_NAME
        }
    }
}

resource "aws_lambda_function" "forgot_password_lambda" {
    filename      = data.archive_file.create_dist_pkg["forgot_password"].output_path
    function_name = "${var.ENV}_forgot_password"
    role          = var.FORGOT_PASSWORD_ROLE_ARN
    handler       = "forgot_password.lambda_handler"

    source_code_hash = data.archive_file.create_dist_pkg["forgot_password"].output_base64sha256
    runtime = local.python_version

    depends_on = [
        data.archive_file.create_dist_pkg["forgot_password"]
    ]

    environment {
        variables = {
            DASHER_CLIENT_ID = "${var.DASHER_CLIENT_ID}"
            USER_CLIENT_ID = "${var.USER_CLIENT_ID}"
            VENDOR_CLIENT_ID = "${var.VENDOR_CLIENT_ID}"
        }
    }
}

resource "aws_lambda_function" "confirm_forgot_password_lambda" {
    filename      = data.archive_file.create_dist_pkg["confirm_forgot_password"].output_path
    function_name = "${var.ENV}_confirm_forgot_password"
    role          = var.CONFIRM_FORGOT_PASSWORD_ROLE_ARN
    handler       = "confirm_forgot_password.lambda_handler"

    source_code_hash = data.archive_file.create_dist_pkg["confirm_forgot_password"].output_base64sha256
    runtime = local.python_version

    depends_on = [
        data.archive_file.create_dist_pkg["confirm_forgot_password"]
    ]

    environment {
        variables = {
            DASHER_CLIENT_ID = "${var.DASHER_CLIENT_ID}"
            USER_CLIENT_ID = "${var.USER_CLIENT_ID}"
            VENDOR_CLIENT_ID = "${var.VENDOR_CLIENT_ID}"
        }
    }
}


# ======================================= CORE ====================================================
resource "aws_lambda_function" "change_password_lambda" {
    filename      = data.archive_file.create_dist_pkg["change_password"].output_path
    function_name = "${var.ENV}_change_password"
    role          = var.CHANGE_PASSWORD_ROLE_ARN
    handler       = "change_password.lambda_handler"

    source_code_hash = data.archive_file.create_dist_pkg["change_password"].output_base64sha256
    runtime = local.python_version

    depends_on = [
        data.archive_file.create_dist_pkg["change_password"]
    ]
}

resource "aws_lambda_function" "delete_user_lambda" {
    filename      = data.archive_file.create_dist_pkg["delete_user"].output_path
    function_name = "${var.ENV}_delete_user"
    role          = var.DELETE_USER_ROLE_ARN
    handler       = "delete_user.lambda_handler"

    source_code_hash = data.archive_file.create_dist_pkg["delete_user"].output_base64sha256
    runtime =  local.python_version

    depends_on = [
        data.archive_file.create_dist_pkg["delete_user"]
    ]

    environment {
        variables = {
            DASHER_POOL_ID = "${var.DASHER_USERPOOL_ID}"
            USER_POOL_ID = "${var.USER_USERPOOL_ID}"
            VENDOR_POOL_ID = "${var.VENDOR_USERPOOL_ID}"

            DASHER_TABLE_NAME = var.DASHER_TABLE_NAME
            USER_TABLE_NAME = var.USER_TABLE_NAME
            VENDOR_TABLE_NAME = var.VENDOR_TABLE_NAME

            # DASHER_USAGE_PLAN = "${var.DASHER_USAGE_PLAN}"
            # USER_USAGE_PLAN = "${var.USER_USAGE_PLAN}"
            # VENDOR_USAGE_PLAN = "${var.VENDOR_USAGE_PLAN}"
        }
    }
}

resource "aws_lambda_function" "view_profile_lambda" {
    filename      = data.archive_file.create_dist_pkg["view_profile"].output_path
    function_name = "${var.ENV}_view_profile"
    role          = var.VIEW_PROFILE_ROLE_ARN
    handler       = "view_profile.lambda_handler"

    source_code_hash = data.archive_file.create_dist_pkg["view_profile"].output_base64sha256
    runtime =  local.python_version

    depends_on = [
        data.archive_file.create_dist_pkg["view_profile"]
    ]

    environment {
        variables = {
            DASHER_TABLE_NAME = var.DASHER_TABLE_NAME
            USER_TABLE_NAME = var.USER_TABLE_NAME
            VENDOR_TABLE_NAME = var.VENDOR_TABLE_NAME
        }
    }
}

resource "aws_lambda_function" "update_profile_lambda" {
    filename      = data.archive_file.create_dist_pkg["update_profile"].output_path
    function_name = "${var.ENV}_update_profile"
    role          = var.UPDATE_PROFILE_ROLE_ARN
    handler       = "update_profile.lambda_handler"
    layers        = [aws_lambda_layer_version.jsonschema.arn]

    source_code_hash = data.archive_file.create_dist_pkg["update_profile"].output_base64sha256
    runtime =  local.python_version

    depends_on = [
        data.archive_file.create_dist_pkg["update_profile"]
    ]

    environment {
        variables = {
            DASHER_TABLE_NAME = var.DASHER_TABLE_NAME
            USER_TABLE_NAME = var.USER_TABLE_NAME
            VENDOR_TABLE_NAME = var.VENDOR_TABLE_NAME
        }
    }
}

# ===================================== AUTHORIZER =================================================
resource "aws_lambda_function" "authorizer_lambda" {
    filename      = data.archive_file.create_dist_pkg["authorizer"].output_path
    function_name = "${var.ENV}_authorizer"
    role          = var.AUTHORIZER_ROLE_ARN
    handler       = "authorizer.lambda_handler"

    source_code_hash = data.archive_file.create_dist_pkg["authorizer"].output_base64sha256
    runtime = local.python_version

    depends_on = [
        data.archive_file.create_dist_pkg["authorizer"]
    ]
}
