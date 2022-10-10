module "vpc" {
  source               = "github.com/devopsravi9/module-vpc"
  VPC_CIDR             = var.VPC_CIDR
  PROJECT              = var.PROJECT
  ENV                  = var.ENV
}