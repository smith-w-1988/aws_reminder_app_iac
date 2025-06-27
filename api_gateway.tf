resource "aws_apigatewayv2_api" "reminder_api" {
  name          = "reminder_api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.reminder_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.reminder_insert.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "post_reminder" {
  api_id    = aws_apigatewayv2_api.reminder_api.id
  route_key = "POST /reminder"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}


resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.reminder_api.id
  name        = "$default"
  auto_deploy = true

  route_settings {
    route_key              = "POST /reminder"
    throttling_burst_limit = 5
    throttling_rate_limit  = 0.0833
  }
}



resource "aws_lambda_permission" "allow_apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.reminder_insert.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.reminder_api.execution_arn}/*/*"
}
