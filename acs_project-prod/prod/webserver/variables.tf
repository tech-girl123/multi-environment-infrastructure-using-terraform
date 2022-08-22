# Instance type
variable "instance_type" {
  default = {
    
    "staging" = "t3.small"
    "prod"    = "t3.medium"
    "dev"     = "t3.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Group_13"
    "App"   = "WebApp"
  }
}

# Prefix to identify resources
variable "prefix" {
  type    = string
  default = "Group_13"
}


# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "dev"
}

variable "ec2_count" {
  type    = number
  default = "0"
}

# Public IP
variable "my_public_ip" {
  type        = string
  description = "Cloud9 Public IP "
  default     = "44.203.216.139"
}

#  Private IP of cloud
variable "my_private_ip" {
  type        = string
  description = "Cloud Private IP "
  default     = "172.31.13.216"
}

variable "desired_size" {
  type        = number
  description = "Desired size for ASG"
  default     = 3
}