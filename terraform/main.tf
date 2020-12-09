module "network" {
  source = "./modules/network"

  resource_prefix = var.resource_prefix
  resource_tags   = var.resource_tags
}

module "s3" {
  source          = "./modules/s3"
  resource_prefix = var.resource_prefix
  resource_tags   = var.resource_tags
}

module "iam" {
  source = "./modules/iam"

  web_instance_policy_attachments = [
    module.s3.ansible_transfer_rw_policy_arn,
    module.s3.backup_bucket_rw_policy_arn
  ]

  resource_prefix = var.resource_prefix
  resource_tags   = var.resource_tags
}

module "webserver" {
  source                = "./modules/ec2"
  instance_size         = var.instance_size
  instance_storage_size = var.instance_storage_size
  vpc_id                = module.network.vpc_id
  subnet_id             = module.network.public_subnets[0]
  instance_role_name    = module.iam.web_instance_role_name
  resource_prefix       = "${var.resource_prefix}-web"
  resource_tags         = var.resource_tags
}

module "dns" {
  source                = "./modules/dns"
  page_root_domain_name = var.page_root_domain_name
  page_full_domain_name = var.page_full_domain_name
  dns_ttl               = var.dns_ttl
  target_ip             = module.webserver.public_ip
}