terraform {
  required_version = ">=0.13.5"

  required_providers {
    tfe = {
      source = "hashicorp/tfe"
      version = "0.26.1"
    }
    aws = {
      version = ">=3.13.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "2.0.0"
    }
    
  }
  backend "remote" {
    organization = "alina-ops"
    workspaces {
      name = "OpsProject2022"
    }
    
  }
}