// Generate ZIP file from the application code.
data "archive_file" "lambda_code" {
  type = "zip"

  source_dir = "../app/"
  output_path = "./app.zip"
}

resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.lambda_code_bucket.id

  // key is an unique identifier for the object stored within the bucket.
  key = "lambda-code.zip"
  source = data.archive_file.lambda_code.output_path

  // An ETag (Entity Tag) is a unique identifier assigned to each object stored in a bucket. It is a
  // hash value that represents the contents of the object.
  // The ETag can be used as a means of verifying the integrity of the object during data transfers
  // or comparisons. When an object is uploaded to S3, Amazon calculates the ETag based on the
  // object's data and metadata. For objects greater than 16MB in size, this may not work though.
  etag = filemd5(data.archive_file.lambda_code.output_path)
}