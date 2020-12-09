
data "aws_ami" "amzn2_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.resource_prefix}-instance-profile"
  role = var.instance_role_name
}

resource "aws_instance" "instance" {
  ami                         = data.aws_ami.amzn2_linux.id
  instance_type               = "t3.nano"
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.id

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.allow_web_traffic.id]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.instance_storage_size
    delete_on_termination = false
  }

  tags = merge(var.resource_tags, {
    "Name" = "${var.resource_prefix}-instance"
  })
}