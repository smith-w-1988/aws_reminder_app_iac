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

resource "aws_dynamodb_table_item" "initial_counter" {
  table_name = aws_dynamodb_table.reminders.name
  hash_key   = "PK"

  item = jsonencode({
    PK   = { S = "COUNTER" }      
    Count = { N = "0" }        
  })

  lifecycle {
    ignore_changes = [item]
  }
}
