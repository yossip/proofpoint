variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "cidr" {
    type = string
    default = "10.0.0.0/16"
    description = "the subnet the VPC should be defined with"
}