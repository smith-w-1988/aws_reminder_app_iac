data "archive_file" "lambda_insert_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_functions/lambda_insert_function.py"
  output_path = "${path.module}/lambda_insert.zip"
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
  environment {
    variables = {
      EXPECTED_API_KEY = var.api_key_secret
    }
  }
}


