variable "functions" {
    type = set(string)
    default = [
        "signup",
        "confirm_signup",
        "signin",
        "resend_confirmation_code",
        "forgot_password",
        "confirm_forgot_password",
        "change_password",
        "delete_user",
        "authorizer",
        "view_profile",
        "update_profile"
    ]
}

variable ENV {}

variable DASHER_TABLE_NAME {}
variable USER_TABLE_NAME {}
variable VENDOR_TABLE_NAME {}

# variable DASHER_USAGE_PLAN {}
# variable USER_USAGE_PLAN {}
# variable VENDOR_USAGE_PLAN {}

variable DASHER_CLIENT_ID {}
variable USER_CLIENT_ID {}
variable VENDOR_CLIENT_ID {}

variable DASHER_USERPOOL_ID {}
variable USER_USERPOOL_ID {}
variable VENDOR_USERPOOL_ID {}

variable SIGNUP_ROLE_ARN {}
variable CONFIRM_SIGNUP_ROLE_ARN {}
variable RESEND_CONFIRMATION_CODE_ROLE_ARN {}
variable SIGNIN_ROLE_ARN {}
variable FORGOT_PASSWORD_ROLE_ARN {}
variable CONFIRM_FORGOT_PASSWORD_ROLE_ARN {}

variable CHANGE_PASSWORD_ROLE_ARN {}
variable DELETE_USER_ROLE_ARN {}
variable VIEW_PROFILE_ROLE_ARN {}
variable UPDATE_PROFILE_ROLE_ARN {}

variable AUTHORIZER_ROLE_ARN {}