variable "database_subnet_group_name" {
  default = ""
  type    = string
}







variable "auth_database_name" {
  description = "List of user and roles ARNs that can access the AWS services."
  type        = string
}

variable "database_users" {
  description = "List of db users"
  type        = list(string)
}

variable "vpc_id" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}

variable "private_subnets_cidr_blocks" {
  type = string
}

