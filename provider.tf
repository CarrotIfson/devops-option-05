terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.25.0"
    }
  }
  #for remote state
  /*
  cloud {
    organization = "devops-tasks"
    workspaces {
      tags = ["option-5"]
    }
  }
  */
}

provider "aws" {
  #for local state
  profile = var.tf_profile

  region = var.aws_region
  default_tags {
    tags = {
      "createdBy:terraform"         = "true"
      "${var.customer}:devops:task" = "5"
      "${var.customer}:env"         = var.env
    }
  }
}