# creating the s3 bucket
resource "aws_s3_bucket" "static_website_bucket" {
  bucket = var.bucket_name # change the name of the bucket in the varibles.tf file
}

# defining the access to the s3 bucket through an acl
resource "aws_s3_bucket_acl" "static_website_bucket_acl" {
  bucket = aws_s3_bucket.static_website_bucket.id
  acl    = "public-read"
}

# making the s3 bucket staging a stati website
resource "aws_s3_bucket_website_configuration" "static_website_buckt_configuration" {
  bucket = aws_s3_bucket.static_website_bucket.bucket

  index_document {
    suffix = "index.html"
  }
}

# upploading the html file for the static website
resource "aws_s3_object" "static_website_bucket_object" {
  bucket = aws_s3_bucket.static_website_bucket.bucket
  key    = "index.html"
  source = "./index.html"
  content_type = "text/html"
}

# linking a policy to the s3 bucket to allow acces to the index.html file
resource "aws_s3_bucket_policy" "allow_access_to_index" {
  bucket = aws_s3_bucket.static_website_bucket.id
  policy = data.aws_iam_policy_document.allow_access_to_index_policy.json
}

# the policy in json format allowing access to the index.html file
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
      "arn:aws:s3:::${var.bucket_name}/index.html"
    ]
  }
}