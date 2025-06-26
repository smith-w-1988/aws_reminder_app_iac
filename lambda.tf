data "archive_file" "lambda_insert_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_insert"
  output_path = "${path.module}/lambda.zip"
}


resource "aws_lambda_function" "reminder_insert" {
  function_name    = "reminder_insert"
  filename         = data.archive_file.lambda_insert_zip.output_path
  source_code_hash = data.archive_file.lambda_insert_zip.output_base64sha256
  handler          = "lambda_insert_function.lambda_handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_dynamodb_role.arn

  depends_on = [
    aws_iam_policy.lambda_dynamodb_put_item
  ]
}


