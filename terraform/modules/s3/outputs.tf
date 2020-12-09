output "ansible_transfer_rw_policy_arn" {
  description = "ARN of the policy that grants rw access to the ansible transfer bucket"
  value       = aws_iam_policy.ansible_transfer_bucket_rw_policy.arn
}

output "ansible_transfer_bucket" {
  description = "Bucket that can be used for data transfer"
  value       = aws_s3_bucket.ansible_transfer_bucket.arn
}

output "backup_bucket_rw_policy_arn" {
  description = "ARN of the policy that grants rw access to the backup  bucket"
  value       = aws_iam_policy.backup_bucket_rw_policy.arn
}

output "backup_bucket" {
  description = "Bucket that can be used for backups"
  value       = aws_s3_bucket.backup_bucket.arn
}