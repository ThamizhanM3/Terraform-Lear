# resource "aws_secretsmanager_secret" "jwt_secret" {
#     name = "${var.project_name}/jwt"
# }

# resource "aws_secretsmanager_secret_version" "jwt_secret_value" {
#     secret_id = aws_secretsmanager_secret.jwt_secret.id

#     secret_string = jsonencode({
#         JWT_SECRET = var.jwt_secret
#     })
# }

data "aws_secretsmanager_secret" "jwt_secret" {
    name = "${var.project_name}/jwt"
}

data "aws_secretsmanager_secret" "mongodb_credentials" {
    name = "${var.project_name}/mongodb"
}

data "aws_secretsmanager_secret_version" "mongodb_credentials" {
    secret_id = data.aws_secretsmanager_secret.mongodb_credentials.id
}