data "archive_file" "lambda_insert_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_functions/lambda_insert_function.py"
  output_path = "${path.module}/lambda_insert.zip"
}

data "archive_file" "lambda_date_selector_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_functions/lambda_date_selector.py"
  output_path = "${path.module}/lambda_date.zip"
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

resource "aws_lambda_function" "date_selector" {
  function_name    = "date_selector"
  filename         = data.archive_file.lambda_date_selector_zip.output_path
  source_code_hash = data.archive_file.lambda_date_selector_zip.output_base64sha256
  handler          = "lambda_date_selector.lambda_handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_dynamodb_role.arn

  depends_on = [
    aws_iam_policy.lambda_dynamodb_put_item
  ]
  environment {
    variables = {
      sender_mail = var.sender_mail
    }
  }
}
