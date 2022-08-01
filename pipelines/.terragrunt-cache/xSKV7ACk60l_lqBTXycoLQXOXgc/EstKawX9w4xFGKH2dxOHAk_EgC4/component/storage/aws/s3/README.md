S3 module
=========

This module creates AWS S3 buckets with a default bucket policy that blocks http connection and only allow access from specific whitelisted IPs.

Module Input Variables
----------------------

- `(Required) bucket_name` - Name of the s3 bucket. Must be unique.
- `(Optional) bucket_acl` - Set Bucket Access Control List. Default is set to private
- `(Required) retention_period` - Set bucket objects retention period.
- `(Required) tags` - Set bucket tags.
- `(Optional) logging` - Map containing access bucket logging configuration.
- `(Optional) custom_policy` - Set custom policy. When variable not defined S3 bucket uses default policy.
- `(Optional) kms_key_id` - If specified use this key to encrypted the contents of the bucket.
- `(Optional) enable_s3_logging_bucket` - When enabled will create logging bucket.


Usage
-----

```
module "s3_bucket" {
  source = "components//storage/aws/s3"

  bucket_name      = bucket
  bucket_acl       = private
  retention_period = 2555
  log_bucket       = security_bucket_arn
  kms_key_id       = "arn:aws:kms:eu-west-2:<aws_account_id>:<kms_key_id>"

  logging = {
    target_bucket = "Logging Bucket Name."
    target_prefix = "bucket/"
  }

  tags = merge(
    {
      "Name"       = "Bucket"
      "Project"    = "Commons"
      "Department" = "AkerCoreProduct"
    }
  )
}
```


Outputs
=======

 - `s3_bucket_arn` - S3 Bucket ARN
 - `s3_bucket_id` - S3 Bucket ID


Authors
=======

lthomai@akersystems.com
