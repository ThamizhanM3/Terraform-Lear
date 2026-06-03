resource "aws_cloudwatch_log_group" "backend_logs" {
    name              = "/m3-music/backend"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "frontend_logs" {
    name              = "/m3-music/frontend"
    retention_in_days = 30
}