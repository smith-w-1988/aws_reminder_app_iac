resource "aws_cloudwatch_event_rule" "daily_reminder_trigger" {
  name                = "daily_reminder_trigger"
  schedule_expression = var.cloudwatch_schedule
}

resource "aws_cloudwatch_event_target" "daily_reminder_lambda" {
  rule      = aws_cloudwatch_event_rule.daily_reminder_trigger.name
  target_id = "dailyReminderLambda"
  arn       = aws_lambda_function.date_selector.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.date_selector.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_reminder_trigger.arn
}
