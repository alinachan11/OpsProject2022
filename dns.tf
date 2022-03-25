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

resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.registration.private_key_pem
  email_address   = var.email_address
}

resource "tls_cert_request" "req" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.registration.private_key_pem}"
  dns_names       = aws_route53_zone.private.name_servers

  subject {
    common_name = var.private_zone_name
  }
}

resource "acme_certificate" "certificate" {
  account_key_pem         = "${acme_registration.registration.account_key_pem}"
  certificate_request_pem = "${tls_cert_request.req.cert_request_pem}"

  dns_challenge {
      provider = var.dns_challenge_provider
      config   = {
        AWS_ACCESS_KEY_ID     = TF_VAR_AWS_ACCESS_KEY_ID
        AWS_SECRET_ACCESS_KEY = TF_VAR_AWS_SECRET_ACCESS_KEY
        AWS_DEFAULT_REGION    = var.aws_region
        AWS_HOSTED_ZONE_ID    = aws_route53_zone.private.id
      }
    }
}

resource "aws_acm_certificate" "cert" {
  private_key        =  acme_certificate.certificate.private_key_pem   
  certificate_body   =  acme_certificate.certificate.certificate_pem 
  certificate_chain  =  acme_certificate.certificate.issuer_pem
  depends_on         =  [acme_certificate.certificate,tls_private_key.registration,acme_registration.registration]
}