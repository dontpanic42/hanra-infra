data "aws_iam_policy" "ssm_instance_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "web_instance_assume_role_policy_document" {
  statement {
    sid    = "1"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "web_instance_role" {
  name               = "${var.resource_prefix}-web-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.web_instance_assume_role_policy_document.json
  tags               = var.resource_tags
}

resource "aws_iam_role_policy_attachment" "web_instance_role_attach_ssm_instance_core" {
  role       = aws_iam_role.web_instance_role.name
  policy_arn = data.aws_iam_policy.ssm_instance_core.arn
}

resource "aws_iam_role_policy_attachment" "web_instance_additonal_attachments" {
  count      = length(var.web_instance_policy_attachments)
  role       = aws_iam_role.web_instance_role.name
  policy_arn = element(var.web_instance_policy_attachments, count.index)
}