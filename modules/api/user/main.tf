data "template_file" "swagger" {
    template = "${file("${path.module}/swagger.yml")}"

    vars = {
        env = var.ENV

        delete_user_uri = var.DELETE_USER_LAMBDA_INVOKE_ARN
        change_password_uri = var.CHANGE_PASSWORD_LAMBDA_INVOKE_ARN

        authorizer_uri = var.AUTHORIZER_LAMBDA_INVOKE_ARN
    }
}

resource "aws_api_gateway_rest_api" "user_api" {
  name = "${var.ENV}_user_dash_eat"
  body = data.template_file.swagger.rendered
  description = "REST API for users in the ${var.ENV} environment"
}

resource "aws_api_gateway_deployment" "user_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.user_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "deployment_stage" {
  deployment_id = aws_api_gateway_deployment.user_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.user_api.id
  stage_name    = var.ENV

  variables = {
    user_type = "user"
  }
}

resource "aws_lambda_permission" "user_api_lambda_permission" {
  for_each = var.core_functions
  action        = "lambda:InvokeFunction"
  function_name = "${var.ENV}_${each.value}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.user_api.execution_arn}/*/*"
}

