output "lambda_api_uri" {
  description = "Hit this URL to invoke the AWS Lambda function"

  value = aws_apigatewayv2_stage.dev.invoke_url
}

output "data_bucket_name" {
  description = "Name of S3 bucket where the data is stored."

  value= random_pet.lambda_code_bucket_name.id
}