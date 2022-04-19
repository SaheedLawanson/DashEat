variable ENV {}
variable API_KEY_SOURCE {}
variable core_functions {
    type = set(string)
    default = [
        "change_password",
        "delete_user",
        "view_profile",
        "update_profile",
        "authorizer"
    ]
}

variable DELETE_USER_LAMBDA_INVOKE_ARN {}
variable CHANGE_PASSWORD_LAMBDA_INVOKE_ARN {}
variable VIEW_PROFILE_LAMBDA_INVOKE_ARN {}
variable UPDATE_PROFILE_LAMBDA_INVOKE_ARN {}

variable AUTHORIZER_LAMBDA_INVOKE_ARN {}