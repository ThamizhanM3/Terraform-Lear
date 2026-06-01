resource "aws_s3_bucket" "s3_bucket" {
    bucket = "${var.project_name}-bucket"

    tags = {
        Name = "${var.project_name}-Bucket"
    }
}


resource "aws_s3_bucket_ownership_controls" "ownership" {
    bucket = aws_s3_bucket.s3_bucket.id

    rule {
        object_ownership = "BucketOwnerEnforced"
    }
}


resource "aws_s3_bucket_public_access_block" "block_public" {
    bucket = aws_s3_bucket.s3_bucket.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}


resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.s3_bucket.id

    versioning_configuration {
        status = "Enabled"
    }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
    bucket = aws_s3_bucket.s3_bucket.id

    rule {
        apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
        }
    }
}
