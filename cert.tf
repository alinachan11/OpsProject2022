############################ variables ###################################
variable "private_key_algorithm" {
  description = "The name of the algorithm to use for private keys. Must be one of: RSA or ECDSA."
  default     = "RSA"
}

variable "private_key_rsa_bits" {
  description = "The size of the generated RSA key in bits. Should only be used if var.private_key_algorithm is RSA."
  default     = 2048
}

variable "validity_period_hours" {
  description = "The number of hours after initial issuing that the certificate will become invalid."
  default     = 8760
}

variable "organization_name" {
  description = "The name of the organization to associate with the certificates (e.g. Acme Co)."
  default     = "alinaops"
}

variable "common_name" {
  description = "The common name to use in the subject of the certificate (e.g. acme.co cert)."
  value = "acme.co"
}

variable "dns_names" {
  description = "List of DNS names for which the certificate will be valid (e.g. foo.example.com)."
  type        = "list"
}

variable "ca_key_algorithm" {
  description = "The name of Algorithm used for CA key"
  value = "ECDSA"
}

variable "ca_private_key_pem" {
  description = "Private key pem of CA"
  value ="cert_prk.pem"
}

variable "allowed_uses" {
  description = "List of keywords from RFC5280 describing a use that is permitted for the issued certificate. For more info and the list of keywords, see https://www.terraform.io/docs/providers/tls/r/self_signed_cert.html#allowed_uses."
  type        = "list"

  default = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

variable "ca_cert_pem" {
  description = "Cert PEM of CA"
  value ="cert_prk.pem"
}

variable "cert_public_key_path" {
  description = "Path to store the certificate public key"
  value = "cert_puk.pem"
}

variable "cert_private_key_path" {
  description = "Path to store the private key of certificate"
  value ="cert_prk.pem"
}

############################ resources ###################################

resource "tls_private_key" "cert" {
  algorithm   = "${var.private_key_algorithm}"
  rsa_bits    = "${var.private_key_rsa_bits}"
}

resource "local_file" "cert_file" {
  content  = "${tls_private_key.cert.private_key_pem}"
  filename = "${var.cert_private_key_path}"
}

resource "tls_cert_request" "cert" {
  key_algorithm   = "${tls_private_key.cert.algorithm}"
  private_key_pem = "${tls_private_key.cert.private_key_pem}"

  dns_names = [module.sd_module.consul_lb_dns,module.jenkins_module.jenkins_lb_dns,aws_lb.elk_alb.dns_name]

  subject {
    common_name  = "${var.common_name}"
    organization = "${var.organization_name}"
  }
}

resource "tls_locally_signed_cert" "cert" {
  cert_request_pem = "${tls_cert_request.cert.cert_request_pem}"

  ca_key_algorithm   = "${var.ca_key_algorithm}"
  ca_private_key_pem = "${var.ca_private_key_pem}"
  ca_cert_pem        = "${var.ca_cert_pem}"

  validity_period_hours = "${var.validity_period_hours}"
  allowed_uses          = ["${var.allowed_uses}"]
}

resource "local_file" "cert_public_key" {
  content  = "${tls_locally_signed_cert.cert.cert_pem}"
  filename = "${var.cert_public_key_path}"
}