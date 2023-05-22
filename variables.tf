variable "region" {
  description = "aws region to work with"
  type        = string
  default     = ""
}
# variable "number_of_azs" {
#   description = "required number of avalibility zones"
#   type        = number
# }
variable "vpc_name" {
  description = "name of the vpc"
  type        = string
  default     = ""
}
variable "vpc_cidr" {
  description = "cidr to use"
  type        = string
  default     = ""
}
variable "vpc_id" {
  description = "vpc id to use"
  type        = string
  default     = ""
}
variable "database_subnet_group_name" {
  description = "name of the database subnet group"
  type        = string
  default     = ""
}
variable "tags" {
  description = "for resources"
  type        = map(string)
  default     = {}
}
variable "aws_security_groups" {
  description = "name of the aws_security_groups"
  type        = string
  default     = ""
}

variable "public_hosted_ip" {
  description = "name of the public hosted ip"
  type        = string
  default     = ""
}