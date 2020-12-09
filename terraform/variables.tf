variable "resource_prefix" {
  type        = string
  default     = "hanra"
  description = "Prefix used for all resource names"
}

variable "instance_size" {
  type        = string
  description = "Family and size of the instance"
  default     = "t3.nano"
}

variable "instance_storage_size" {
  type        = number
  description = "Size of the root volume of the instance"
  default     = 10
}

variable "page_root_domain_name" {
  type        = string
  description = "Root domain (=zone) to run this app in"
  default     = "bytelike.de"
}

variable "page_full_domain_name" {
  type        = string
  description = "Full domain name of the app"
  default     = "hanra.bytelike.de"
}

variable "dns_ttl" {
  type        = number
  description = "TTL for A records"
  default     = 300
}

variable "resource_tags" {
  type        = map(string)
  description = "Tags to attach to all resources"
  default = {
    "env" = "prod"
    "app" = "hanra.bytelike.de"
  }
}