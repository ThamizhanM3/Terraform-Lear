terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 6.0"
        }
    }
}


terraform {
    backend "s3" {
        bucket         = "my-terraform-state-bucket-12345"
        key            = "dev/terraform.tfstate"
        region         = "ap-south-1"
        dynamodb_table = "terraform-locks"
        encrypt        = true
    }
}
