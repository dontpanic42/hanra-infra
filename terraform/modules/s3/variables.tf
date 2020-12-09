variable "resource_prefix" {
  type        = string
  description = "Prefix used for all resource names"
}

variable "resource_tags" {
  type        = map(string)
  description = "Tags to attach to all resources"
}