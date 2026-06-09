resource "aws_lambda_permission" "allow_eventbridge" {
    statement_id = "AllowExecutionFromEventBridge"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.hourly_report.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.hourly_upload_report.arn
}

resource "aws_lambda_permission" "allow_s3" {
    statement_id = "AllowS3Invoke"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.upload_logger.function_name
    principal = "s3.amazonaws.com"
    source_arn = aws_s3_bucket.songs_bucket.arn
}

resource "aws_s3_bucket_notification" "songs_upload_notification" {
    bucket = aws_s3_bucket.songs_bucket.id
    lambda_function {
        lambda_function_arn = aws_lambda_function.upload_logger.arn
        events = [ "s3:ObjectCreated:*" ]
    }
    depends_on = [ aws_lambda_permission.allow_s3 ]
}