resource "aws_route53_zone" "private" {
  name = "${var.private_zone_name}"
  vpc {
    vpc_id = module.vpc_module.vpc_id
  }
}

resource "aws_route53_record" "myConsulRecord" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "${var.private_zone_name}"
  type    = "A" 

  alias {
      name                   = module.sd_module.consul_lb_dns
      zone_id                = module.sd_module.consul_lb_zone_id
      evaluate_target_health = true
  }
}