resource "aws_iam_role" "lambda_dynamodb_role" {
  name = "lambda_dynamodb_role"

    assume_role_policy = file("${path.module}/policies/lambda_dynamodb_policy.json")
}

resource "aws_iam_policy" "lambda_dynamodb_put_item" {
  name   = "lambda_dynamodb_put_item"
  policy = templatefile("${path.module}/policies/dynamodb_put_item_policy.json", {
    table_arn = aws_dynamodb_table.reminders.arn
  })
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_put_item_attach" {
  role       = aws_iam_role.lambda_dynamodb_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_put_item.arn
}
