# ================================== SIGNUP ==========================================
resource "aws_iam_role" "signup_role" {
  name = "${var.ENV}_signup_role"

  assume_role_policy = "${file("${path.module}/lambda_role.json")}"
}

# ================================== CONFIRM SIGNUP ==================================
resource "aws_iam_role" "confirm_signup_role" {
  name = "${var.ENV}_confirm_signup_role"

  assume_role_policy = "${file("${path.module}/lambda_role.json")}"
}

# =========================== RESEND CONFIRMATION CODE =================================
resource "aws_iam_role" "resend_confirmation_code_role" {
  name = "${var.ENV}_resend_confirmation_code_role"

  assume_role_policy = "${file("${path.module}/lambda_role.json")}"
}

# ================================== SIGNIN ============================================
resource "aws_iam_role" "signin_role" {
  name = "${var.ENV}_signin_role"

  assume_role_policy = "${file("${path.module}/lambda_role.json")}"
}

# ============================ FORGOT PASSWORD ============================================
resource "aws_iam_role" "forgot_password_role" {
  name = "${var.ENV}_forgot_password_role"

  assume_role_policy = "${file("${path.module}/lambda_role.json")}"
}

# ========================== CONFIRM FORGOT PASSWORD ============================================
resource "aws_iam_role" "confirm_forgot_password_role" {
  name = "${var.ENV}_confirm_forgot_password_role"

  assume_role_policy = "${file("${path.module}/lambda_role.json")}"
}


# ========================== CHANGE PASSWORD ============================================
resource "aws_iam_role" "change_password_role" {
  name = "${var.ENV}_change_password_role"

  assume_role_policy = "${file("${path.module}/lambda_role.json")}"
}

# ========================== DELETE USER ============================================
resource "aws_iam_role" "delete_user_role" {
  name = "${var.ENV}_delete_user_role"

  assume_role_policy = "${file("${path.module}/lambda_role.json")}"
}

# ========================== VIEW PROFILE ============================================
resource "aws_iam_role" "view_profile_role" {
  name = "${var.ENV}_view_profile_role"

  assume_role_policy = "${file("${path.module}/lambda_role.json")}"
}

# ========================== UPDATE PROFILE ============================================
resource "aws_iam_role" "update_profile_role" {
  name = "${var.ENV}_update_profile_role"

  assume_role_policy = "${file("${path.module}/lambda_role.json")}"
}

# ===================================================================================================================================================
# ============================ AUTHORIZER =======================================
resource "aws_iam_role" "authorizer_role" {
  name = "${var.ENV}_authorizer_role"

  assume_role_policy = "${file("${path.module}/lambda_role.json")}"
}
