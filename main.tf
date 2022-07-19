terraform {
  required_version = ">= 0.14.0"
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }
    wireguard = {
      source  = "ojford/wireguard"
      version = "0.2.1+1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }
  }
}
