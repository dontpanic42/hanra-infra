resource "aws_s3_bucket" "ansible_transfer_bucket" {
  bucket        = "${var.resource_prefix}-ansible-transfer"
  acl           = "private"
  force_destroy = true

  tags = merge(var.resource_tags, {
    "Name" = "${var.resource_prefix}-ansible-transfer"
  })
}

data "aws_iam_policy_document" "web_instance_transfer_rw_role_policy_document" {
  statement {
    sid    = "1"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.ansible_transfer_bucket.arn
    ]
  }

  statement {
    sid    = "2"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]

    resources = [
      aws_s3_bucket.ansible_transfer_bucket.arn,
      "${aws_s3_bucket.ansible_transfer_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "ansible_transfer_bucket_rw_policy" {
  name        = "${var.resource_prefix}-ansible-transfer"
  path        = "/"
  description = "Grants r/w access to the ansible transfer bucket"
  policy      = data.aws_iam_policy_document.web_instance_transfer_rw_role_policy_document.json
}