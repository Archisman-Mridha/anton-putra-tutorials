resource "aws_lambda_function" "lambda" {
  function_name = "say-hello"

  s3_bucket = aws_s3_bucket.lambda_code_bucket.id
  s3_key = aws_s3_object.lambda_code.key

  runtime = "nodejs16.x"
  handler = "main.handler"

  // Used to trigger updates.
  source_code_hash = data.archive_file.lambda_code.output_base64sha256

  role = aws_iam_role.lambda.arn
}