resource "aws_iam_role" "lambda" {
  // When the AWS Lambda function tries to acess other AWS resources, it needs to assume an IAM role.
  // This policy grants the AWS Lambda function permission to assume that role.
  assume_role_policy = file("./lambda.iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_policy" {
  role = aws_iam_role.lambda.name

  // This policy is designed to provide the minimum necessary permissions for an AWS Lambda function
  // to execute successfully.
  // The AWS Lambda function can thus log to CloudWatch, assume its own exeution role etc.
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// IAM policy to allow the AWS Lambda function to access the data at path /data in the S3 bucket.
resource "aws_iam_policy" "s3_bucket_access" {
  policy = jsonencode(
    {
      Version= "2012-10-17",
      Statement= [
        {
          Action= [ "s3:GetObject" ],
          Effect= "Allow",
          Resource= "arn:aws:s3:::${aws_s3_bucket.lambda_code_bucket.id}/data.json"
        }
      ]
    }
  )
}
resource "aws_iam_role_policy_attachment" "s3_bucket_access" {
  role = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.s3_bucket_access.arn
}