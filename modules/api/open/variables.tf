variable ENV {}
variable open_functions {
    type = set(string)
    default = [
        "signup",
        "confirm_signup",
        "signin",
        "resend_confirmation_code",
        "forgot_password",
        "confirm_forgot_password",
    ]
}

variable SIGNUP_LAMBDA_INVOKE_ARN {}
variable CONFIRM_SIGNUP_LAMBDA_INVOKE_ARN {}
variable SIGNIN_LAMBDA_INVOKE_ARN {}
variable FORGOT_PASSWORD_LAMBDA_INVOKE_ARN {}
variable CONFIRM_FORGOT_PASSWORD_LAMBDA_INVOKE_ARN {}
variable RESEND_CONFIRMATION_CODE_LAMBDA_INVOKE_ARN {}