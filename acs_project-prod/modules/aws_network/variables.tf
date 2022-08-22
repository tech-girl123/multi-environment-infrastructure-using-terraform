# Default tags
variable "default_tags" {
  default     = {}
  type        = map(any)
  description = "Default tag"
}

# Name prefix
variable "prefix" {
  default= "project"
  type        = string
  description = "Name prefix"
}

# VPC CIDR range
variable "vpc_cidr" {
  type        = string
  description = "VPC to host static web site"
}

# Provision public subnets in custom VPC
variable "public_cidr_blocks" {
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision private subnets in custom VPC
variable "private_cidr_blocks" {
  type        = list(string)
  description = "Private Subnet CIDRs"
}


# Variable to signal the current environment 
variable "env" {
  type        = string
  description = "prod"
}