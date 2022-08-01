variable "database_subnet_group_name" {
  default = ""
  type    = string
}

variable "auth_database_name" {
  description = "List of database_names"
  default = ""
  type        = string
}

variable "database_users" {
  description = "List of db users"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = ""
}

variable "db_subnet_group_name" {
  type = string
}

variable "private_subnets_cidr_blocks" {
  type = string
}

variable "tags" {
  type    = map(any)
  default = {}
}



