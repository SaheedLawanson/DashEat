# ============================ SIGN UP ====================================
data "aws_iam_policy_document" "signup_policy_doc" {
  statement {
    # sid       = "Sign_up"
    actions    = [
      "cognito-idp:SignUp"
    ]
    effect    = "Allow"
    resources  = ["*"]
  }

  statement {
      # sid         = "Stmt1647557083427"
      actions      = [
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:UpdateTable",
      "dynamodb:PutItem"
    ]
      effect      = "Allow"
      resources    = ["*"]
  }

  statement {
      # sid         = "Stmt1647557083427"
      actions      = [
      "apigateway:POST"
    ]
      effect      = "Allow"
      resources    = [
        "arn:aws:apigateway:*::/apikeys/*",
        "arn:aws:apigateway:*::/apikeys",
        "arn:aws:apigateway:*::/usageplans/*/keys"
      ]
  }
}

resource "aws_iam_policy" "signup_policy" {
  name        = "${var.ENV}_signup_policy"
  policy = data.aws_iam_policy_document.signup_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "signup_policy_attachment" {
  policy_arn = aws_iam_policy.signup_policy.arn
  role = var.SIGNUP_ROLE_NAME
}


# ========================= CONFIRM SIGN UP ==================================
data "aws_iam_policy_document" "confirm_signup_policy_doc" {
  statement {
    # sid       = "confirm_signup"
    actions    = [
      "cognito-idp:ConfirmSignUp"
    ]
    effect    = "Allow"
    resources  = ["*"]
  }
}

resource "aws_iam_policy" "confirm_signup_policy" {
  name        = "${var.ENV}_confirm_signup_policy"
  policy = data.aws_iam_policy_document.confirm_signup_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "confirm_signup_policy_attachment" {
  policy_arn = aws_iam_policy.confirm_signup_policy.arn
  role = var.CONFIRM_SIGNUP_ROLE_NAME
}

# =========================== RESEND CONFIRMATION CODE =============================
data "aws_iam_policy_document" "resend_confirmation_code_policy_doc" {
  statement {
    # sid       = "Resend_confirmation_code"
    actions    = [
      "cognito-idp:ResendConfirmationCode"
    ]
    effect    = "Allow"
    resources  = ["*"]
  }
}

resource "aws_iam_policy" "resend_confirmation_code_policy" {
  name        = "${var.ENV}_resend_confirmation_code_policy"
  policy = data.aws_iam_policy_document.resend_confirmation_code_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "resend_confirmation_code_policy_attachment" {
  policy_arn = aws_iam_policy.resend_confirmation_code_policy.arn
  role = var.RESEND_CONFIRMATION_CODE_ROLE_NAME
}


# ================================= SIGN IN ==================================
data "aws_iam_policy_document" "signin_policy_doc" {
  statement {
    # sid       = "Sign_in"
    actions    = [
      "cognito-idp:SignIn"
    ]
    effect    = "Allow"
    resources  = ["*"]
  }

  statement {
      # sid         = "Stmt1647557083427"
      actions      = [
      "dynamodb:GetItem",
    ]
      effect      = "Allow"
      resources    = ["*"]
  }

}

resource "aws_iam_policy" "signin_policy" {
  name        = "${var.ENV}_signin_policy"
  policy = data.aws_iam_policy_document.signin_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "signin_policy_attachment" {
  policy_arn = aws_iam_policy.signin_policy.arn
  role = var.SIGNIN_ROLE_NAME
}

# ============================= FORGOT PASSWORD ==================================
data "aws_iam_policy_document" "forgot_password_policy_doc" {
  statement {
    # sid       = "Claim_forgot_password"
    actions    = [
      "cognito-idp:ForgotPassword"
    ]
    effect    = "Allow"
    resources  = ["*"]
  }
}

resource "aws_iam_policy" "forgot_password_policy" {
  name        = "${var.ENV}_forgot_password_policy"
  policy = data.aws_iam_policy_document.forgot_password_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "forgot_password_policy_attachment" {
  policy_arn = aws_iam_policy.forgot_password_policy.arn
  role = var.FORGOT_PASSWORD_ROLE_NAME
}

# =========================== CONFIRM FORGOT PASSWORD =============================
data "aws_iam_policy_document" "confirm_forgotten_password_policy_doc" {
  statement {
    # sid       = "confirm_forgot_password"
    actions    = [
      "cognito-idp:ConfirmForgotPassword"
    ]
    effect    = "Allow"
    resources  = ["*"]
  }
}

resource "aws_iam_policy" "confirm_forgotten_password_policy" {
  name        = "${var.ENV}_confirm_forgotten_password_policy"
  policy = data.aws_iam_policy_document.confirm_forgotten_password_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "confirm_forgotten_password_policy_attachment" {
  policy_arn = aws_iam_policy.confirm_forgotten_password_policy.arn
  role = var.CONFIRM_FORGOT_PASSWORD_ROLE_NAME
}

# =============================== CHANGE PASSWORD ===================================
data "aws_iam_policy_document" "change_password_policy_doc" {
  statement {
    # sid       = "Authorize_users"
    actions    = [
      "cognito-idp:ChangePassword"
    ]
    effect    = "Allow"
    resources  = ["*"]
  }
}

resource "aws_iam_policy" "change_password_policy" {
  name        = "${var.ENV}_change_password_policy"
  policy = data.aws_iam_policy_document.change_password_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "change_password_policy_attachment" {
  policy_arn = aws_iam_policy.change_password_policy.arn
  role = var.CHANGE_PASSWORD_ROLE_NAME
}

# =============================== DELETE USER ===================================
data "aws_iam_policy_document" "delete_user_policy_doc" {
  statement {
    # sid       = "Delete_from_pool"
    actions    = [
      "cognito-idp:DeleteUser"
    ]
    effect    = "Allow"
    resources  = ["*"]
  }

  statement {
    # sid       = "Delete_from_table"
    actions    = [
      "dynamodb:DeleteItem"
    ]
    effect    = "Allow"
    resources  = ["*"]
  }

  statement {
    # sid         = "Delete from API keys"
    actions      = [
      "apigateway:POST"
    ]
    effect      = "Allow"
    resources    = [
      "arn:aws:apigateway:*::/apikeys/*",
      "arn:aws:apigateway:*::/apikeys",
    ]
  }
}


resource "aws_iam_policy" "delete_user_policy" {
  name        = "${var.ENV}_delete_user_policy"
  policy = data.aws_iam_policy_document.delete_user_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "delete_user_policy_attachment" {
  policy_arn = aws_iam_policy.delete_user_policy.arn
  role = var.DELETE_USER_ROLE_NAME
}

# =============================== VIEW PROFILE ===================================
data "aws_iam_policy_document" "view_profile_policy_doc" {
  statement {
    actions    = [
      "dynamodb:GetItem"
    ]
    effect    = "Allow"
    resources  = ["*"]
  }
}

resource "aws_iam_policy" "view_profile_policy" {
  name        = "${var.ENV}_view_profile_policy"
  policy = data.aws_iam_policy_document.view_profile_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "view_profile_policy_attachment" {
  policy_arn = aws_iam_policy.view_profile_policy.arn
  role = var.VIEW_PROFILE_ROLE_NAME
}

# =============================== UPDATE PROFILE ===================================
data "aws_iam_policy_document" "update_profile_policy_doc" {
  statement {
    # sid       = "Delete_from_table"
    actions    = [
      "dynamodb:UpdateItem",
      "dynamodb:GetItem"
    ]
    effect    = "Allow"
    resources  = ["*"]
  }
}

resource "aws_iam_policy" "update_profile_policy" {
  name        = "${var.ENV}_update_profile_policy"
  policy = data.aws_iam_policy_document.update_profile_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "update_profile_policy_attachment" {
  policy_arn = aws_iam_policy.update_profile_policy.arn
  role = var.UPDATE_PROFILE_ROLE_NAME
}

# ===================================================================================================================================================
# =================================== AUTHORIZER =======================================
data "aws_iam_policy_document" "authorizer_policy_doc" {
  statement {
    # sid       = "Authorize_users"
    actions    = [
      "cognito-idp:GetUser"
    ]
    effect    = "Allow"
    resources  = ["*"]
  }
}

resource "aws_iam_policy" "authorizer_policy" {
  name        = "${var.ENV}_authorizer_policy"
  policy = data.aws_iam_policy_document.authorizer_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "authorizer_policy_attachment" {
  policy_arn = aws_iam_policy.authorizer_policy.arn
  role = var.AUTHORIZER_ROLE_NAME
}