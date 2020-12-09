variable "web_instance_policy_attachments" {
  type        = list(string)
  description = "Policies to attach to web instance roles"
  default     = []
}

variable "resource_prefix" {
  type        = string
  description = "Prefix used for all resource names"
}

variable "resource_tags" {
  type        = map(string)
  description = "Tags to attach to all resources"
}