resource "aws_s3_bucket" "app_bucket" {
    bucket = "${var.project_name}-bucket"

    tags = {
        Name = "${var.project_name}-Bucket"
    }
}
