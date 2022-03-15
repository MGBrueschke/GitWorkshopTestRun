resource "aws_s3_bucket" "static_website_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "static_website_bucket_acl" {
  bucket = aws_s3_bucket.static_website_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "static_website_buckt_configuration" {
  bucket = aws_s3_bucket.static_website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}

resource "aws_s3_bucket_object" "static_website_bucket_object" {
  bucket = aws_s3_bucket.static_website_bucket.bucket
  key    = "index.html"
  source = "./index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_policy" "allow_access_to_index" {
  bucket = aws_s3_bucket.static_website_bucket.id
  policy = data.aws_iam_policy_document.allow_access_to_index_policy.json
}

data "aws_iam_policy_document" "allow_access_to_index_policy" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

     actions = [
      "s3:GetObject" 
    ]

    resources = [
      aws_s3_bucket.static_website_bucket.arn,
      "arn:aws:s3:::trc-git-workshop-webiste-bucket/index.html"
    ]
  }
}