
################################################################################
# Common
################################################################################

variable "region" {
  description = "The selected AWS region."
  type        = string
  default     = "eu-central-1"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default = {
    Project = "Terraform-AWS-VPC-Module"
  }
}

variable "prefix" {
  description = "A prefix that will be appended to all resources."
  type        = string
  default     = "tavm"
}


################################################################################
# VPC
################################################################################

variable "vpc_cidr" {
  description = "The main VPC CIDR block."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_az_count" {
  description = "The number of Availability Zones in the VPC."
  type        = number
  default     = 3
}
