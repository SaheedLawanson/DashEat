# ROLE NAMES
output SIGNUP_ROLE_NAME {
    value = aws_iam_role.signup_role.name
}

output CONFIRM_SIGNUP_ROLE_NAME {
    value = aws_iam_role.confirm_signup_role.name
}

output RESEND_CONFIRMATION_CODE_ROLE_NAME {
    value = aws_iam_role.resend_confirmation_code_role.name
}

output SIGNIN_ROLE_NAME {
    value = aws_iam_role.signin_role.name
}

output FORGOT_PASSWORD_ROLE_NAME {
    value = aws_iam_role.forgot_password_role.name
}

output CONFIRM_FORGOT_PASSWORD_ROLE_NAME {
    value = aws_iam_role.confirm_forgot_password_role.name
}

output CHANGE_PASSWORD_ROLE_NAME {
    value = aws_iam_role.change_password_role.name
}

output DELETE_USER_ROLE_NAME {
    value = aws_iam_role.delete_user_role.name
}

output VIEW_PROFILE_ROLE_NAME {
    value = aws_iam_role.view_profile_role.name
}

output UPDATE_PROFILE_ROLE_NAME {
    value = aws_iam_role.update_profile_role.name
}

output AUTHORIZER_ROLE_NAME {
    value = aws_iam_role.authorizer_role.name
}

# ROLE ARNs
output SIGNUP_ROLE_ARN {
    value = aws_iam_role.signup_role.arn
}

output CONFIRM_SIGNUP_ROLE_ARN {
    value = aws_iam_role.confirm_signup_role.arn
}

output RESEND_CONFIRMATION_CODE_ROLE_ARN {
    value = aws_iam_role.resend_confirmation_code_role.arn
}

output SIGNIN_ROLE_ARN {
    value = aws_iam_role.signin_role.arn
}

output FORGOT_PASSWORD_ROLE_ARN {
    value = aws_iam_role.forgot_password_role.arn
}

output CONFIRM_FORGOT_PASSWORD_ROLE_ARN {
    value = aws_iam_role.confirm_forgot_password_role.arn
}

output CHANGE_PASSWORD_ROLE_ARN {
    value = aws_iam_role.change_password_role.arn
}

output DELETE_USER_ROLE_ARN {
    value = aws_iam_role.delete_user_role.arn
}

output VIEW_PROFILE_ROLE_ARN {
    value = aws_iam_role.view_profile_role.arn
}

output UPDATE_PROFILE_ROLE_ARN {
    value = aws_iam_role.update_profile_role.arn
}

output AUTHORIZER_ROLE_ARN {
    value = aws_iam_role.authorizer_role.arn
}