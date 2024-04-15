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

}

resource "aws_s3_bucket_website_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }

}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.allow_access_policy.json
}

data "aws_iam_policy_document" "allow_access_policy" {
  statement {

    sid    = "PublicReadGetObject"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}

resource "aws_s3_object" "upload_files" {
  for_each = fileset("${path.module}/site", "**/*")

  bucket = aws_s3_bucket.bucket.id
  key    = each.value
  source = "${path.module}/site/${each.value}"
  content_type = "text/html"

  depends_on = [
    aws_s3_bucket.bucket,
  ]
}
