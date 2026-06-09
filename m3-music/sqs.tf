# resource "aws_sqs_queue" "upload_events_queue" {
#     name = "${var.project_name}-upload-events"

#     visibility_timeout_seconds = 300

#     tags = {
#         Name = "${var.project_name}-upload-events"
#     }
# }