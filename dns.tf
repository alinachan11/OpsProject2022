resource "aws_route53_zone" "private" {
  name = "${var.private_zone_name}"
  vpc {
    vpc_id = module.vpc_module.vpc_id
  }
}




resource "aws_route53_record" "myConsulRecord" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "consul.${var.private_zone_name}"
  type    = "A" 

  alias {
      name                   = module.sd_module.consul_lb_dns
      zone_id                = module.sd_module.consul_lb_zone_id
      evaluate_target_health = true
  }
}

resource "aws_route53_record" "myJenkinsRecord" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "Jenkins.${var.private_zone_name}"
  type    = "A" 
  alias {
      name                   = module.jenkins_module.jenkins_lb_dns
      zone_id                = module.jenkins_module.jenkins_lb_zone_id
      evaluate_target_health = true
  }
}
resource "aws_route53_record" "myELKRecord" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "ELK.${var.private_zone_name}"
  type    = "A" 

  alias {
      name                   = aws_lb.elk_alb.dns_name
      zone_id                = aws_lb.elk_alb.zone_id
      evaluate_target_health = true
  }
}


############################################################################