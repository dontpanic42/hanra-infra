data "aws_route53_zone" "my_zone" {
  name         = "${var.page_root_domain_name}."
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.my_zone.zone_id
  name    = var.page_full_domain_name
  type    = "A"
  ttl     = var.dns_ttl
  records = [var.target_ip]
}