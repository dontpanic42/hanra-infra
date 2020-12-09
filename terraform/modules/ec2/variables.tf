variable "instance_size" {
  type        = string
  description = "Family and size of the instance"
}

variable "instance_storage_size" {
  type        = number
  description = "Size of the root volume of the instance"
}

variable "vpc_id" {
  type        = string
  description = "Id of the VPC to run in"
}

variable "subnet_id" {
  type        = string
  description = "Id of the subnet to run in"
}

variable "instance_role_name" {
  type        = string
  description = "IAM role this instance runs with"
}

variable "resource_prefix" {
  type        = string
  description = "Prefix used for all resource names"
}

variable "resource_tags" {
  type        = map(string)
  description = "Tags to attach to all resources"
}