IAM User Module
=========

This module creates multiple users belonging to a single group with default generic permissions to access an S3 bucket.

Module Input Variables
----------------------

- `(Required) name` - name used to disambiguate resources.
- `(Required) group_name` - Name of the group
- `(Required) users` - Array of users to be created and associated with the group
- `(Required) bucket_arn_path_list` - List of bucket ARNs/paths to be allowed
- `(Required) bucket_kms_arn_list` - List of bucket KMS ARNs to be allowed
- `(Required) tags` - Set Role tags such as (department,project etc..)

Usage
-----

```
module "iam_user" {
  source = "components//security/aws/iam_user"

  name        = "demo"
  group_name  = "my_group"
  users       = [ "user1", "user2" ]

  bucket_arn_path_list = [
    "arn:aws:s3:::mde-s3-archive-test-datasource-notprod/*",
    "arn:aws:s3:::mde-s3-archive-test-datasource-notprod/",
    "arn:aws:s3:::mde-s3-deposit-test-datasource-notprod/*",
    "arn:aws:s3:::mde-s3-deposit-test-datasource-notprod/"
  ]

  bucket_kms_arn_list = [
    "arn:aws:kms:eu-west-2:1234567890:key/30d1cd86-e036-4e4b-9d07-39e8cdcc232c"
  ]

  tags = merge(
    {
      "Project"    = "Project Name"
      "Department" = "Department Name"
    }
  )
}
```


Outputs
=======

 - `user_name` - List of users arn
 - `group_arn` - Group ARN


Authors
=======

lthomai@akersystems.com
pniemiec@akersystems.com
