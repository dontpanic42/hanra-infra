variable "page_root_domain_name" {
  type        = string
  description = "Root domain (=zone) to run this app in"
}

variable "page_full_domain_name" {
  type        = string
  description = "Full domain name of the app"
}

variable "dns_ttl" {
  type        = number
  description = "TTL for A records"
}

variable "target_ip" {
  type        = string
  description = "IP to point the A record at"
}