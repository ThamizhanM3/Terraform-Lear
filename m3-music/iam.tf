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

        Statement = [{
        Effect = "Allow"

        Action = [
            "secretsmanager:GetSecretValue"
        ]

        Resource = aws_secretsmanager_secret.jwt_secret.arn
        }]
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