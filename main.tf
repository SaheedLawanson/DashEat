locals {

}

# =========================================== DYNAMODB =================================================
# Users
module "user_dynamodb" {
    source = "./modules/dynamodb"

    ENV = var.env
    RESOURCE_PREFIX = "user"
    TAGS = local.tags
}

# Vendors
module "vendor_dynamodb" {
    source = "./modules/dynamodb"

    ENV = var.env
    RESOURCE_PREFIX = "vendor"
    TAGS = local.tags
}

# Dashers
module "dasher_dynamodb" {
    source = "./modules/dynamodb"

    ENV = var.env
    RESOURCE_PREFIX = "dasher"
    TAGS = local.tags
}

# # Vendor locations
# module "vendor_locations_dynamodb" {
#     source = "./modules/dynamodb"

#     ENV = var.env
#     RESOURCE_PREFIX = "vendor_location"
#     TAGS = local.tags
# }

# # Orders
# module "order_dynamodb" {
#     source = "./modules/dynamodb"

#     ENV = var.env
#     RESOURCE_PREFIX = "order"
#     TAGS = local.tags
# }

# # Transactions
# module "transaction_dynamodb" {
#     source = "./modules/dynamodb"

#     ENV = var.env
#     RESOURCE_PREFIX = "transaction"
#     TAGS = local.tags
# }

# # Menus
# module "menu_dynamodb" {
#     source = "./modules/dynamodb"

#     ENV = var.env
#     RESOURCE_PREFIX = "menu"
#     TAGS = local.tags
# }

# # Schedule
# module "schedule_dynamodb" {
#     source = "./modules/dynamodb"

#     ENV = var.env
#     RESOURCE_PREFIX = "schedule"
#     TAGS = local.tags
# }

# ======================================== COGNITO ==========================================================
module "cognito_userpool" {
    source = "./modules/cognito"
    ENV = var.env
}

module "cognito_app_client" {
    source = "./modules/cognito_app_client"
    ENV = var.env

    DASHER_USERPOOL_ID = module.cognito_userpool.DASHER_USERPOOL_ID
    USER_USERPOOL_ID = module.cognito_userpool.USER_USERPOOL_ID
    VENDOR_USERPOOL_ID = module.cognito_userpool.VENDOR_USERPOOL_ID
}

# ======================================= ROLES & POLICIES ======================================================
module "roles" {
    source = "./modules/role"
    ENV = var.env
}

module "policies" {
    source = "./modules/policy"
    ENV = var.env

    SIGNUP_ROLE_NAME = module.roles.SIGNUP_ROLE_NAME
    CONFIRM_SIGNUP_ROLE_NAME = module.roles.CONFIRM_SIGNUP_ROLE_NAME
    RESEND_CONFIRMATION_CODE_ROLE_NAME = module.roles.RESEND_CONFIRMATION_CODE_ROLE_NAME
    SIGNIN_ROLE_NAME = module.roles.SIGNIN_ROLE_NAME
    FORGOT_PASSWORD_ROLE_NAME = module.roles.FORGOT_PASSWORD_ROLE_NAME
    CONFIRM_FORGOT_PASSWORD_ROLE_NAME = module.roles.CONFIRM_FORGOT_PASSWORD_ROLE_NAME

    CHANGE_PASSWORD_ROLE_NAME = module.roles.CHANGE_PASSWORD_ROLE_NAME
    DELETE_USER_ROLE_NAME = module.roles.DELETE_USER_ROLE_NAME
    VIEW_PROFILE_ROLE_NAME = module.roles.VIEW_PROFILE_ROLE_NAME
    UPDATE_PROFILE_ROLE_NAME = module.roles.UPDATE_PROFILE_ROLE_NAME

    AUTHORIZER_ROLE_NAME = module.roles.AUTHORIZER_ROLE_NAME
}

# ================================================ LAMBDAS ===========================================================
module "lambdas" {
    source = "./modules/lambda"
    ENV = var.env

    # TABLES
    DASHER_TABLE_NAME = module.dasher_dynamodb.TABLE_NAME
    USER_TABLE_NAME = module.user_dynamodb.TABLE_NAME
    VENDOR_TABLE_NAME = module.vendor_dynamodb.TABLE_NAME

    # # USAGE PLANS
    # DASHER_USAGE_PLAN = module.dasher_api.USAGE_PLAN
    # USER_USAGE_PLAN = module.user_api.USAGE_PLAN
    # VENDOR_USAGE_PLAN = module.vendor_api.USER_USAGE_PLAN

    # COGNITO POOLS
    DASHER_USERPOOL_ID = module.cognito_userpool.DASHER_USERPOOL_ID
    USER_USERPOOL_ID = module.cognito_userpool.USER_USERPOOL_ID
    VENDOR_USERPOOL_ID = module.cognito_userpool.VENDOR_USERPOOL_ID

    # COGNITO APP CLIENTS
    DASHER_CLIENT_ID = module.cognito_app_client.DASHER_CLIENT_ID
    USER_CLIENT_ID = module.cognito_app_client.USER_CLIENT_ID
    VENDOR_CLIENT_ID = module.cognito_app_client.VENDOR_CLIENT_ID

    # ROLES FOR OPEN LAMBDAS
    SIGNUP_ROLE_ARN = module.roles.SIGNUP_ROLE_ARN
    CONFIRM_SIGNUP_ROLE_ARN = module.roles.CONFIRM_SIGNUP_ROLE_ARN
    RESEND_CONFIRMATION_CODE_ROLE_ARN = module.roles.RESEND_CONFIRMATION_CODE_ROLE_ARN
    SIGNIN_ROLE_ARN = module.roles.SIGNIN_ROLE_ARN
    FORGOT_PASSWORD_ROLE_ARN = module.roles.FORGOT_PASSWORD_ROLE_ARN
    CONFIRM_FORGOT_PASSWORD_ROLE_ARN = module.roles.CONFIRM_FORGOT_PASSWORD_ROLE_ARN

    # ROLES FOR CORE LAMBDAS
    CHANGE_PASSWORD_ROLE_ARN = module.roles.CHANGE_PASSWORD_ROLE_ARN
    DELETE_USER_ROLE_ARN = module.roles.DELETE_USER_ROLE_ARN
    VIEW_PROFILE_ROLE_ARN = module.roles.VIEW_PROFILE_ROLE_ARN
    UPDATE_PROFILE_ROLE_ARN = module.roles.UPDATE_PROFILE_ROLE_ARN

    # ROLE FOR AUTHORIZER LAMBDA
    AUTHORIZER_ROLE_ARN = module.roles.AUTHORIZER_ROLE_ARN
}

# =================================================== APIS =======================================================
module "open_api" {
    source = "./modules/api/open"
    ENV = var.env

    SIGNUP_LAMBDA_INVOKE_ARN = module.lambdas.SIGNUP_LAMBDA_INVOKE_ARN
    CONFIRM_SIGNUP_LAMBDA_INVOKE_ARN = module.lambdas.CONFIRM_SIGNUP_LAMBDA_INVOKE_ARN
    RESEND_CONFIRMATION_CODE_LAMBDA_INVOKE_ARN = module.lambdas.RESEND_CONFIRMATION_CODE_LAMBDA_INVOKE_ARN
    SIGNIN_LAMBDA_INVOKE_ARN = module.lambdas.SIGNIN_LAMBDA_INVOKE_ARN
    FORGOT_PASSWORD_LAMBDA_INVOKE_ARN = module.lambdas.FORGOT_PASSWORD_LAMBDA_INVOKE_ARN
    CONFIRM_FORGOT_PASSWORD_LAMBDA_INVOKE_ARN = module.lambdas.CONFIRM_FORGOT_PASSWORD_LAMBDA_INVOKE_ARN
}

module "dasher_api" {
    source = "./modules/api/dasher"
    ENV = var.env

    DELETE_USER_LAMBDA_INVOKE_ARN = module.lambdas.DELETE_USER_LAMBDA_INVOKE_ARN
    CHANGE_PASSWORD_LAMBDA_INVOKE_ARN = module.lambdas.CHANGE_PASSWORD_LAMBDA_INVOKE_ARN
    VIEW_PROFILE_LAMBDA_INVOKE_ARN = module.lambdas.VIEW_PROFILE_LAMBDA_INVOKE_ARN
    UPDATE_PROFILE_LAMBDA_INVOKE_ARN = module.lambdas.UPDATE_PROFILE_LAMBDA_INVOKE_ARN

    AUTHORIZER_LAMBDA_INVOKE_ARN = module.lambdas.AUTHORIZER_LAMBDA_INVOKE_ARN

}

module "user_api" {
    source = "./modules/api/user"
    ENV = var.env

    DELETE_USER_LAMBDA_INVOKE_ARN = module.lambdas.DELETE_USER_LAMBDA_INVOKE_ARN
    CHANGE_PASSWORD_LAMBDA_INVOKE_ARN = module.lambdas.CHANGE_PASSWORD_LAMBDA_INVOKE_ARN

    AUTHORIZER_LAMBDA_INVOKE_ARN = module.lambdas.AUTHORIZER_LAMBDA_INVOKE_ARN
}

module "vendor_api" {
    source = "./modules/api/vendor"
    ENV = var.env

    DELETE_USER_LAMBDA_INVOKE_ARN = module.lambdas.DELETE_USER_LAMBDA_INVOKE_ARN
    CHANGE_PASSWORD_LAMBDA_INVOKE_ARN = module.lambdas.CHANGE_PASSWORD_LAMBDA_INVOKE_ARN

    AUTHORIZER_LAMBDA_INVOKE_ARN = module.lambdas.AUTHORIZER_LAMBDA_INVOKE_ARN
}

module "usage_plan" {
    source = "./modules/api/api_usage_plan"

    ENV = var.env

    DASHER_API_ID = module.dasher_api.API_ID
    USER_API_ID = module.user_api.API_ID
    VENDOR_API_ID = module.vendor_api.API_ID

    depends_on = [
      module.user_api,
      module.vendor_api,
      module.dasher_api
    ]
}

