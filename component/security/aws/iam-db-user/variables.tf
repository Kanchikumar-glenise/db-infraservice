variable "name" {
  description = "Module name to disambiguate resources"
  type        = string
}

variable "users" {
  description = "Users that belong to the group"
  type        = list(any)
}

variable "tags" {
  type    = map(any)
  default = {}
}
