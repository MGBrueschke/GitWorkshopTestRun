terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = ">= 4.0"
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      ProjectName = "Git-Workshop"
      Owner = "Max Gordon Brueschke"
      Enviormente = "Dev"
    }
  }
}