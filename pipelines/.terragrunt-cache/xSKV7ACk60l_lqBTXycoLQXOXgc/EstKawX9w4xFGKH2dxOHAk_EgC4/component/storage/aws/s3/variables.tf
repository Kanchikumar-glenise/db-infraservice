variable "bucket_name" {
  description = "Name of the s3 bucket. Must be unique."
  type        = string
}

variable "bucket_acl" {
  description = "Set Bucket Access Control List. Default is set to private"
  type        = string
  default     = "log-delivery-write"
}

variable "retention_period" {
  description = "Set bucket objects retention period."
  type        = number
}

variable "log_bucket" {
  description = "The log bucket name"
  default     = ""
  type        = string
}

variable "tags" {
  description = "Tags to set on the bucket."
  type        = map(string)
  default     = {}
}

variable "acp_vpn_ips" {
  description = "ACP VPN IPs."
  type        = list(string)
}

variable "acp_cluster_ips" {
  description = "ACP Cluster IPs."
  type        = list(string)
}

variable "acp_ci_ips" {
  description = "ACP CI IPs."
  type        = list(string)
}

variable "aws_ips" {
  type = list(string)
}

variable "gov_wifi_ips" {
  description = "GOV WIFI IPs."
  type        = list(string)
}

variable "custom_policy" {
  description = "Set custom policy. When variable not defined S3 bucket uses default policy."
  default     = ""
}

variable "kms_key_id" {
  description = "If specified use this key to encrypted the contents of the bucket."
  default     = ""
}

variable "logging" {
  description = "Map containing access bucket logging configuration."
  type        = map(string)
  default     = {}
}
