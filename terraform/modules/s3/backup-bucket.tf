resource "aws_s3_bucket" "backup_bucket" {
  bucket        = "${var.resource_prefix}-backup"
  acl           = "private"
  force_destroy = true

  tags = merge(var.resource_tags, {
    "Name" = "${var.resource_prefix}-backup"
  })
}

data "aws_iam_policy_document" "backup_bucket_rw_policy_document" {
  statement {
    sid    = "1"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.backup_bucket.arn
    ]
  }

  statement {
    sid    = "2"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.backup_bucket.arn,
      "${aws_s3_bucket.backup_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "backup_bucket_rw_policy" {
  name        = "${var.resource_prefix}-backup-policy"
  path        = "/"
  description = "Grants r/w access to the backup bucket"
  policy      = data.aws_iam_policy_document.backup_bucket_rw_policy_document.json
}