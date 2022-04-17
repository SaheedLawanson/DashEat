output DASHER_USERPOOL_ID {
    value = aws_cognito_user_pool.dasher_userpool.id
}

output USER_USERPOOL_ID {
    value = aws_cognito_user_pool.user_userpool.id
}

output VENDOR_USERPOOL_ID {
    value = aws_cognito_user_pool.vendor_userpool.id
}