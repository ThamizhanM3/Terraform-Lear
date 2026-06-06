resource "aws_kms_key" "songs_kms" {
    description             = "KMS key for songs bucket"
    deletion_window_in_days = 7
    enable_key_rotation     = true
}

resource "aws_kms_alias" "songs_kms_alias" {
    name          = "alias/${var.project_name}-songs-key"
    target_key_id = aws_kms_key.songs_kms.key_id
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key_policy" "songs_kms_policy" {
    key_id = aws_kms_key.songs_kms.id

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Sid = "EnableRootPermissions"
                Effect = "Allow",
                Principal = {
                    AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
                },
                Action = "kms:*",
                Resource = "*"
            },
            {
                Sid = "AllowS3Usage",
                Effect = "Allow",
                Principal = {
                    Service = "s3.amazonaws.com"
                },
                Action = [
                    "kms:Encrypt",
                    "kms:Decrypt",
                    "kms:GenerateDataKey*",
                    "kms:DescribeKey"
                ],
                Resource = "*"
            },
            {
                Sid = "AllowBackendRoleUsage",
                Effect = "Allow",
                Principal = {
                    AWS = aws_iam_role.backend_role.arn
                },
                Action = [
                    "kms:GenerateDataKey",
                    "kms:Encrypt",
                    "kms:Decrypt",
                    "kms:DescribeKey"
                ],
                Resource = "*"
            }
        ]
    })
}