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

  dynamic "external_account_binding" {
    for_each = var.external_account_binding != null ? [null] : []
    content {
      key_id      = var.external_account_binding.key_id
      hmac_base64 = var.external_account_binding.hmac_base64
    }
  }
}

resource "acme_certificate" "certificates" {
  for_each = { for certificate in var.certificates : index(var.certificates, certificate) => certificate }

  common_name               = each.value.common_name
  subject_alternative_names = each.value.subject_alternative_names
  key_type                  = each.value.key_type
  must_staple               = each.value.must_staple
  min_days_remaining        = each.value.min_days_remaining
  certificate_p12_password  = each.value.certificate_p12_password
  account_key_pem              = acme_registration.registration.account_key_pem
  recursive_nameservers        = var.recursive_nameservers
  disable_complete_propagation = var.disable_complete_propagation
  pre_check_delay              = var.pre_check_delay

  dns_challenge {
      provider = var.dns_challenge_provider
      config   = {
        AWS_ACCESS_KEY_ID     = AWS_ACCESS_KEY_ID
        AWS_SECRET_ACCESS_KEY = AWS_SECRET_ACCESS_KEY
        AWS_DEFAULT_REGION    = var.aws_region
        AWS_HOSTED_ZONE_ID    = aws_route53_zone.private.id
      }
    }
}

resource "aws_acm_certificate" "cert" {
  private_key        =  acme_certificate.certificates[0].private_key_pem   
  certificate_body   =  acme_certificate.certificates[0].certificate_pem 
  certificate_chain  =  acme_certificate.certificates[0].issuer_pem
  depends_on         =  [acme_certificate.certificates,tls_private_key.registration,acme_registration.registration]
}