terraform {
  
  required_version = ">=1.7.5"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.44.0"
    }
  }

}

provider "aws" {
  region  = "us-east-1"
  
  default_tags {
    tags = {
      owner = "BrunoFigueiredo"
      managed-by = "terraform"
    }
  }

}

resource "aws_s3_bucket" "bucket" {

  bucket = "devops-ifmt-brunofigueiredo"

  tags = {
    owner = "BrunoFigueiredo"
    managed-by = "terraform"
  }
  
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  depends_on = [
    aws_s3_bucket.bucket
  ]
}