resource "aws_iam_role" "frontend_role" {
    name = "${var.project_name}-frontend-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"

        Statement = [{
        Effect = "Allow"

        Principal = {
            Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role" "backend_role" {
    name = "${var.project_name}-backend-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"

        Statement = [{
        Effect = "Allow"

        Principal = {
            Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_policy" "s3_upload_policy" {
    name = "${var.project_name}-s3-upload-policy"

    policy = jsonencode({
        Version = "2012-10-17"

        Statement = [
        {
            Effect = "Allow"

            Action = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject"
            ]

            Resource = [
            "${aws_s3_bucket.songs_bucket.arn}/*"
            ]
        },
        {
            Effect = "Allow"

            Action = [
            "s3:ListBucket"
            ]

            Resource = [
            aws_s3_bucket.songs_bucket.arn
            ]
        }
        ]
    })
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
    name = "${var.project_name}-cloudwatch-logs"

    policy = jsonencode({
        Version = "2012-10-17"

        Statement = [{
        Effect = "Allow"

        Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams"
        ]

        Resource = "*"
        }]
    })
}

resource "aws_iam_policy" "secrets_manager_policy" {
    name = "${var.project_name}-secrets-manager"

    policy = jsonencode({
        Version = "2012-10-17"

        Statement = [
            {
                Effect = "Allow"

                Action = [
                    "secretsmanager:GetSecretValue",
                    "secretsmanager:DescribeSecret"
                ]

                Resource = [
                    "${data.aws_secretsmanager_secret.mongodb_credentials.arn}",
                    "${data.aws_secretsmanager_secret.jwt_secret.arn}"
                ]
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "backend_s3_attachment" {
    role       = aws_iam_role.backend_role.name
    policy_arn = aws_iam_policy.s3_upload_policy.arn
}

resource "aws_iam_role_policy_attachment" "backend_cloudwatch_attachment" {
    role       = aws_iam_role.backend_role.name
    policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

resource "aws_iam_role_policy_attachment" "frontend_cloudwatch_attachment" {
    role       = aws_iam_role.frontend_role.name
    policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

resource "aws_iam_instance_profile" "frontend_profile" {
    name = "${var.project_name}-frontend-profile"
    role = aws_iam_role.frontend_role.name
}

resource "aws_iam_instance_profile" "backend_profile" {
    name = "${var.project_name}-backend-profile"
    role = aws_iam_role.backend_role.name
}

resource "aws_iam_role_policy_attachment" "backend_secrets_attachment" {
    role       = aws_iam_role.backend_role.name
    policy_arn = aws_iam_policy.secrets_manager_policy.arn
}

resource "aws_iam_policy" "ecr_pull_policy" {
    name = "${var.project_name}-ecr-pull-policy"

    policy = jsonencode({
        Version = "2012-10-17"

        Statement = [
        {
            Effect = "Allow"

            Action = [
            "ecr:GetAuthorizationToken"
            ]

            Resource = "*"
        },
        {
            Effect = "Allow"

            Action = [
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage"
            ]

            Resource = "*"
        }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "backend_ecr_attachment" {
    role       = aws_iam_role.backend_role.name
    policy_arn = aws_iam_policy.ecr_pull_policy.arn
}

resource "aws_iam_role_policy_attachment" "frontend_ecr_attachment" {
    role       = aws_iam_role.frontend_role.name
    policy_arn = aws_iam_policy.ecr_pull_policy.arn
}

resource "aws_iam_policy" "kms_usage_policy" {
    name = "${var.project_name}-kms-usage"

    policy = jsonencode({
        Version = "2012-10-17"

        Statement = [
        {
            Effect = "Allow"

            Action = [
                "kms:GenerateDataKey",
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:DescribeKey"
            ]

            Resource = aws_kms_key.songs_kms.arn
        }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "backend_kms_attachment" {
    role       = aws_iam_role.backend_role.name
    policy_arn = aws_iam_policy.kms_usage_policy.arn
}

resource "aws_iam_role" "lambda_role" {
    name = "${var.project_name}-lambda-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"

        Statement = [{
            Effect = "Allow"

            Principal = {
                Service = "lambda.amazonaws.com"
            }

            Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_policy" "lambda_custom_policy" {

    name = "${var.project_name}-lambda-custom"

    policy = jsonencode({
        Version = "2012-10-17"

        Statement = [

            {
                Effect = "Allow"

                Action = [
                    "dynamodb:PutItem",
                    "dynamodb:GetItem",
                    "dynamodb:Query",
                    "dynamodb:Scan"
                ]

                Resource = aws_dynamodb_table.upload_events.arn
            },

            # {
            #     Effect = "Allow"

            #     Action = [
            #         "sqs:ReceiveMessage",
            #         "sqs:DeleteMessage",
            #         "sqs:GetQueueAttributes"
            #     ]

            #     Resource = aws_sqs_queue.upload_events_queue.arn
            # },

            {
                Effect = "Allow"

                Action = [
                    "sns:Publish"
                ]

                Resource = aws_sns_topic.hourly_upload_report.arn
            },
            {
                Effect = "Allow"

                Action = [
                    "secretsmanager:GetSecretValue",
                    "secretsmanager:DescribeSecret"
                ]

                Resource = [
                    "${data.aws_secretsmanager_secret.mongodb_credentials.arn}",
                    "${data.aws_secretsmanager_secret.jwt_secret.arn}"
                ]
            }

        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_custom_attachment" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.lambda_custom_policy.arn
}

resource "aws_iam_role" "database_role" {
    name = "${var.project_name}-database-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"

        Statement = [{
            Effect = "Allow"

            Principal = {
                Service = "ec2.amazonaws.com"
            }

            Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_policy" "database_secrets_policy" {
    name = "${var.project_name}-database-secrets"

    policy = jsonencode({
        Version = "2012-10-17"

        Statement = [{
            Effect = "Allow"

            Action = [
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret"
            ]

            Resource = [
                "${data.aws_secretsmanager_secret.mongodb_credentials.arn}",
                "${data.aws_secretsmanager_secret.jwt_secret.arn}"
            ]
        }]
    })
}

resource "aws_iam_role_policy_attachment" "database_secret_attachment" {
    role       = aws_iam_role.database_role.name
    policy_arn = aws_iam_policy.database_secrets_policy.arn
}

resource "aws_iam_instance_profile" "database_profile" {
    name = "${var.project_name}-database-profile"
    role = aws_iam_role.database_role.name
}

resource "aws_iam_policy" "report_lambda_policy" {
    name = "${var.project_name}-report-lambda-policy"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [ "dynamodb:Scan" ]
                Resource = aws_dynamodb_table.upload_events.arn
            },
            {
                Effect = "Allow"
                Action = [ "sns:Publish" ]
                Resource = aws_sns_topic.hourly_upload_report.arn
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "report_lambda_attachment" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.report_lambda_policy.arn
}

# resource "aws_iam_role_policy_attachment" "backend_ssm" {
#     role       = aws_iam_role.backend_role.name
#     policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# resource "aws_iam_role_policy_attachment" "frontend_ssm" {
#     role       = aws_iam_role.frontend_role.name
#     policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

resource "aws_iam_policy" "ssm_core_custom" {
    name = "${var.project_name}-ssm-core-policy"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "ssm:DescribeAssociation",
                    "ssm:GetDeployablePatchSnapshotForInstance",
                    "ssm:GetDocument",
                    "ssm:DescribeDocument",
                    "ssm:GetManifest",
                    "ssm:GetParameter",
                    "ssm:GetParameters",
                    "ssm:ListAssociations",
                    "ssm:ListInstanceAssociations",
                    "ssm:PutInventory",
                    "ssm:PutComplianceItems",
                    "ssm:PutConfigurePackageResult",
                    "ssm:UpdateAssociationStatus",
                    "ssm:UpdateInstanceAssociationStatus",
                    "ssm:UpdateInstanceInformation"
                ],
                Resource = "*"
            },
            {
                Effect = "Allow"
                Action = [
                    "ssmmessages:CreateControlChannel",
                    "ssmmessages:CreateDataChannel",
                    "ssmmessages:OpenControlChannel",
                    "ssmmessages:OpenDataChannel"
                ],
                Resource = "*"
            },
            {
                Effect = "Allow"
                Action = [
                    "ec2messages:AcknowledgeMessage",
                    "ec2messages:DeleteMessage",
                    "ec2messages:FailMessage",
                    "ec2messages:GetEndpoint",
                    "ec2messages:GetMessages",
                    "ec2messages:SendReply"
                ],
                Resource = "*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "frontend_ssm_custom" {
    role       = aws_iam_role.frontend_role.name
    policy_arn = aws_iam_policy.ssm_core_custom.arn
}

resource "aws_iam_role_policy_attachment" "backend_ssm_custom" {
    role       = aws_iam_role.backend_role.name
    policy_arn = aws_iam_policy.ssm_core_custom.arn
}

resource "aws_iam_role_policy_attachment" "database_ssm_custom" {
    role       = aws_iam_role.database_role.name
    policy_arn = aws_iam_policy.ssm_core_custom.arn
}

