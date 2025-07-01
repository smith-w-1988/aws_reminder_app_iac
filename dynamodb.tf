resource "aws_dynamodb_table" "reminders" {
  name           = "reminders"
  billing_mode   = "PROVISIONED"
  read_capacity  = 25
  write_capacity = 25
  hash_key       = "PK"

  attribute {
    name = "PK"
    type = "S"
  }
}