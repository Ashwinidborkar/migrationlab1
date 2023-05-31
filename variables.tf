# variable "region" {
#   description = "aws region to work with"
#   type        = string
#   default     = ""
# }
# # variable "number_of_azs" {
# #   description = "required number of avalibility zones"
# #   type        = number
# # }
# variable "vpc_name" {
#   description = "name of the vpc"
#   type        = string
#   default     = ""
# }
# # variable "vpc_cidr" {
# #   description = "cidr to use"
# #   type        = string
# # }
# variable "vpc_id" {
#   description = "vpc id to use"
#   type        = string
#   default     = ""
# }
# variable "database_subnet_group_name" {
#   description = "name of the database subnet group"
#   type        = string
#   default     = ""
# }
# variable "tags" {
#   description = "for resources"
#   type        = map(string)
#   default     = {}
# }
# variable "aws_security_groups" {
#   description = "name of the aws_security_groups"
#   type        = string
#   default     = ""
# }
# variable "public_hosted_ip" {
#   description = "name of the public hosted ip"
#   type        = string
#   default     = ""
# }

variable "ami_for_appserver" {
  description = "name of the onprem server"
  type        = string
  default     = ""
}

variable "rds_username" {
  description = "name of the user"
  type        = string
  default     = ""
}

variable "rds_name" {
  description = "name of the user"
  type        = string
  default     = ""
}

variable "restore_to_point_in_time" {
  description = "nested block: NestingList, min items: 0, max items: 1"
  type = set(object(
    {
      restore_time                  = string
      source_db_instance_identifier = string
      source_dbi_resource_id        = string
      use_latest_restorable_time    = bool
    }
  ))
  default = []
}

variable "peer_owner_id" {
  description = "Id of account"
  type        = string
  default     = ""
}
variable "password-for-dms" {
  description = "password of account"
  type        = string
  default     = ""
}



