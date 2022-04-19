data "template_file" "swagger" {
    template = "${file("${path.module}/swagger.yml")}"

    vars = {
        env = var.ENV

        delete_user_uri = var.DELETE_USER_LAMBDA_INVOKE_ARN
        change_password_uri = var.CHANGE_PASSWORD_LAMBDA_INVOKE_ARN
        view_profile_uri = var.VIEW_PROFILE_LAMBDA_INVOKE_ARN
        update_profile_uri = var.UPDATE_PROFILE_LAMBDA_INVOKE_ARN

        authorizer_uri = var.AUTHORIZER_LAMBDA_INVOKE_ARN
    }
}


resource "aws_api_gateway_rest_api" "dasher_api" {
    name = "${var.ENV}_dasher_dash_eat"
    body = data.template_file.swagger.rendered
    api_key_source = var.API_KEY_SOURCE
    description = "REST API for dashers in the ${var.ENV} environment"
}

resource "aws_api_gateway_deployment" "dasher_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.dasher_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.dasher_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "deployment_stage" {
  deployment_id = aws_api_gateway_deployment.dasher_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.dasher_api.id
  stage_name    = var.ENV

  variables = {
    user_type = "dasher"
  }
}

resource "aws_lambda_permission" "dasher_api_lambda_permission" {
  for_each = var.core_functions
  action        = "lambda:InvokeFunction"
  function_name = "${var.ENV}_${each.value}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.dasher_api.execution_arn}/*/*"
}

