output "backup_bucket" {
  description = "Bucket that can be used for backups"
  value       = module.s3.backup_bucket
}

output "ansible_transfer_bucket" {
  description = "Bucket that can be used for data transfer"
  value       = module.s3.ansible_transfer_bucket
}