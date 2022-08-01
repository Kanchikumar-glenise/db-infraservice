locals {

  default_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Sid": "HTTP",
        "Effect": "Deny",
        "Principal": "*",
        "Action": "*",
        "Resource": [
          "arn:aws:s3:::${var.bucket_name}/*",
          "arn:aws:s3:::${var.bucket_name}"
        ],
        "Condition": {
            "Bool": {
                "aws:SecureTransport": "false"
            }
        }
    },
    {
      "Sid": "IPAllow",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::${var.bucket_name}/*",
        "arn:aws:s3:::${var.bucket_name}"
      ],
      "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": [
            "${join("\", \"", concat(var.gov_wifi_ips,
  var.acp_vpn_ips,
  var.acp_cluster_ips,
  var.acp_ci_ips,
var.aws_ips))}"
          ]
        },
        "Bool": {
          "aws:ViaAWSService": "true"
        }
      }
     }
   ]
}
POLICY
custom_policy = var.custom_policy != "" ? var.custom_policy : local.default_policy
}


resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_logging" "s3_bucket" {
  for_each      = var.logging
  bucket        = aws_s3_bucket.s3_bucket.id
  target_bucket = each.value.target_bucket
  target_prefix = lookup(each.value, "target_prefix", null)
}

resource "aws_s3_bucket_policy" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = local.custom_policy
}

resource "aws_s3_bucket_public_access_block" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = var.bucket_acl
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id == "" ? "" : var.kms_key_id
      sse_algorithm     = var.kms_key_id == "" ? "AES256" : "aws:kms"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    id     = "Keep previous version ${var.retention_period} days"
    status = "Enabled"

    expiration {
      days = var.retention_period
    }
  }
}


