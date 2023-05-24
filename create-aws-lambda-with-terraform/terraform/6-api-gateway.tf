resource "aws_apigatewayv2_api" "lambda" {
  name = "lambda"
  protocol_type = "HTTP"
}

// A stage represents a deployment environment for your API.
// Each stage can have its own configuration settings, such as authentication, caching, and
// throttling, allowing you to customize the behavior of your API in different environments.
resource "aws_apigatewayv2_stage" "dev" {
  api_id = aws_apigatewayv2_api.lambda.id

  name = "dev"
  auto_deploy = true

  // Optionally, you can enable logging.
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri = aws_lambda_function.lambda.invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

// Granting the API Gateway permission to execute the AWS Lambda function.
resource "aws_lambda_permission" "apigateway" {
  statement_id = "AllowExecutionFromAPIGateway"

  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

// ROUTES

resource "aws_apigatewayv2_route" "get" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /"
  target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_route" "post" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /"
  target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}