output STAGE_ID {
    value = aws_api_gateway_stage.deployment_stage.id
}

output API_ID {
    value = aws_api_gateway_rest_api.vendor_api.id
}