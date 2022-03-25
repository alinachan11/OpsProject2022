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


#############################################################################

provider "acme" {
  server_url = var.acme_server_url
}

resource "tls_private_key" "registration" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_acm_certificate" "my_cert" {
  domain_name       = var.private_zone_name
  validation_method = "DNS"

  tags = {
    Environment = "test"
    Owner = "alina"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.my_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.private.zone_id
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.my_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}