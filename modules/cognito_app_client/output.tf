output DASHER_CLIENT_ID {
    value = aws_cognito_user_pool_client.dasher_client.id
}

output USER_CLIENT_ID {
    value = aws_cognito_user_pool_client.user_client.id
}

output VENDOR_CLIENT_ID {
    value = aws_cognito_user_pool_client.vendor_client.id
}