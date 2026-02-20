terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
 
  access_key = "AKIA6OQZCNQGP73HYCC2"

  secret_key = "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"

}

