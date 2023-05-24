resource "random_pet" "lambda_code_bucket_name" {
  prefix = "lambda"
  length = 2
}

resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = random_pet.lambda_code_bucket_name.id

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "lambda_code_bucket" {
  bucket = aws_s3_bucket.lambda_code_bucket.id

  // Following attributes are used to block any public access to the bucket.

  // ACL stands for Access Control List. An ACL is a set of permissions that defines who can access
  // and perform actions on objects stored in an S3 bucket. An ACL works at the object level.
  block_public_acls = true
  ignore_public_acls = true

  block_public_policy = true

  restrict_public_buckets = true
}

// The AWS Lambda function will access this data and return it as response on receiving a
// POST request.
resource "aws_s3_object" "data" {
  bucket = aws_s3_bucket.lambda_code_bucket.id

  key = "data.json"
  content = jsonencode({ success= "true" })
}