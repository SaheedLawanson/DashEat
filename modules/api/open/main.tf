data "template_file" "swagger" {
    template = "${file("${path.module}/swagger.yml")}"

    vars = {
        env = var.ENV
        signup_uri = var.SIGNUP_LAMBDA_INVOKE_ARN
        confirm_signup_uri = var.CONFIRM_SIGNUP_LAMBDA_INVOKE_ARN
        signin_uri = var.SIGNIN_LAMBDA_INVOKE_ARN
        forgot_password_uri = var.FORGOT_PASSWORD_LAMBDA_INVOKE_ARN
        confirm_forgot_password_uri = var.CONFIRM_FORGOT_PASSWORD_LAMBDA_INVOKE_ARN
        resend_confirmation_code_uri = var.RESEND_CONFIRMATION_CODE_LAMBDA_INVOKE_ARN
    }
}


resource "aws_api_gateway_rest_api" "open_api" {
    name = "${var.ENV}_open_dash_eat"
    body = data.template_file.swagger.rendered
    description = "REST API for DashEat open api in the ${var.ENV} environment"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.open_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.open_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_api_gateway_rest_api.open_api]
}

resource "aws_api_gateway_stage" "deployment_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.open_api.id
  stage_name    = var.ENV
}

resource "aws_lambda_permission" "api_lambda_permission" {
  for_each = var.open_functions
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.ENV}_${each.value}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.open_api.execution_arn}/*/*"

  depends_on = [
    aws_api_gateway_rest_api.open_api
  ]
}
