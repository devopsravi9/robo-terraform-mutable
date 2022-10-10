


module "vpc" {
  source               = "github.com/devopsravi9/module-vpc"
  VPC_CIDR             = var.VPC_CIDR
  PROJECT              = var.PROJECT
  ENV                  = var.ENV
  PRIVATE_CIDR         = var.PRIVATE_CIDR
  PUBLIC_CIDR          = var.PUBLIC_CIDR
  AZ                   = var.AZ
  DEFAULT_VPC_ID       = var.DEFAULT_VPC_ID
  DEFAULT_ROUTE_TABLE_ID = var.DEFAULT_ROUTE_TABLE_ID
  DEFAULT_CIDR         = var.DEFAULT_CIDR
}

module "rds" {
  source = "github.com/devopsravi9/module-rds"
  PROJECT              = var.PROJECT
  ENV                  = var.ENV
  ENGINE               = var.ENGINE
  ENGINE_VERSION       = var.ENGINE_VERSION
  INSTANCE_CLASS       = var.INSTANCE_CLASS
  RDS_PG_FAMILY        = var.RDS_PG_FAMILY
  RDS_PORT             = var.RDS_PORT
  VPC_ID               = module.vpc.VPC_ID
  PRIVATE_SUBNET_CIDR  = module.vpc.PRIVATE_SUBNET_CIDR
  PRIVATE_SUBNET_ID    = module.vpc.PRIVATE_SUBNET_ID

}