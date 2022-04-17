output SIGNUP_LAMBDA_INVOKE_ARN {
    value = aws_lambda_function.signup_lambda.invoke_arn
}

output CONFIRM_SIGNUP_LAMBDA_INVOKE_ARN {
    value = aws_lambda_function.confirm_signup_lambda.invoke_arn
}

output RESEND_CONFIRMATION_CODE_LAMBDA_INVOKE_ARN {
    value = aws_lambda_function.resend_confirmation_code_lambda.invoke_arn
}

output SIGNIN_LAMBDA_INVOKE_ARN {
    value = aws_lambda_function.signin_lambda.invoke_arn
}

output FORGOT_PASSWORD_LAMBDA_INVOKE_ARN {
    value = aws_lambda_function.forgot_password_lambda.invoke_arn
}

output CONFIRM_FORGOT_PASSWORD_LAMBDA_INVOKE_ARN {
    value = aws_lambda_function.confirm_forgot_password_lambda.invoke_arn
}

output CHANGE_PASSWORD_LAMBDA_INVOKE_ARN {
    value = aws_lambda_function.change_password_lambda.invoke_arn
}

output DELETE_USER_LAMBDA_INVOKE_ARN {
    value = aws_lambda_function.delete_user_lambda.invoke_arn
}

output VIEW_PROFILE_LAMBDA_INVOKE_ARN {
    value = aws_lambda_function.view_profile_lambda.invoke_arn
}

output UPDATE_PROFILE_LAMBDA_INVOKE_ARN {
    value = aws_lambda_function.update_profile_lambda.invoke_arn
}

output AUTHORIZER_LAMBDA_INVOKE_ARN {
    value = aws_lambda_function.authorizer_lambda.invoke_arn
}