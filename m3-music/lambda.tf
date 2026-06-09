resource "aws_lambda_function" "upload_logger" {
    function_name = "${var.project_name}-upload-logger"
    package_type = "Image"
    image_uri = var.upload_lambda_image
    role = aws_iam_role.lambda_role.arn
    timeout = 60
    memory_size = 512
    vpc_config {
        subnet_ids = [
            aws_subnet.backend_subnet_a.id,
            aws_subnet.backend_subnet_b.id
        ]
        security_group_ids = [ aws_security_group.lambda_sg.id ]
    }

    environment {
        variables = {
            MONGO_SECRET_NAME = data.aws_secretsmanager_secret.mongodb_credentials.name
            DATABASE_IP       = aws_instance.database_instance.private_ip
            DATABASE_PORT     = var.database_port
            MONGO_DB_NAME     = "m3-music"
            DYNAMODB_TABLE    = aws_dynamodb_table.upload_events.name
        }
    }
}

resource "aws_lambda_function" "hourly_report" {
    function_name = "${var.project_name}-hourly-report"
    package_type = "Image"
    image_uri = var.report_lambda_image
    role = aws_iam_role.lambda_role.arn
    timeout = 300
    memory_size = 512
    vpc_config {
        subnet_ids = [
            aws_subnet.backend_subnet_a.id,
            aws_subnet.backend_subnet_b.id
        ]

        security_group_ids = [
            aws_security_group.lambda_sg.id
        ]
    }

    environment {
        variables = {
            DYNAMODB_TABLE = aws_dynamodb_table.upload_events.name
            SNS_TOPIC_ARN = aws_sns_topic.hourly_upload_report.arn
            DATABASE_IP   = aws_instance.database_instance.private_ip
        }
    }
}

# resource "aws_lambda_event_source_mapping" "upload_events_mapping" {
#     event_source_arn = aws_sqs_queue.upload_events_queue.arn
#     function_name = aws_lambda_function.upload_logger.arn
#     batch_size = 10
# }