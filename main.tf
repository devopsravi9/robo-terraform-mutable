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
  PROJECT                = var.PROJECT
  ENV                    = var.ENV
  RDS_ENGINE             = var.RDS_ENGINE
  RDS_ENGINE_VERSION     = var.RDS_ENGINE_VERSION
  RDS_INSTANCE_CLASS     = var.RDS_INSTANCE_CLASS
  RDS_PG_FAMILY          = var.RDS_PG_FAMILY
  RDS_PORT               = var.RDS_PORT
  VPC_ID                 = module.vpc.VPC_ID
  PRIVATE_SUBNET_ID      = module.vpc.PRIVATE_SUBNET_ID
  ALLOW_SG_CIDR          = concat( module.vpc.PRIVATE_SUBNET_CIDR, tolist([var.WORKSTATION_IP]))
}

module "docdb" {
  source = "github.com/devopsravi9/module-docdb"
  PROJECT                = var.PROJECT
  ENV                    = var.ENV
  DOCDB_ENGINE           = var.DOCDB_ENGINE
  DOCDB_ENGINE_VERSION   = var.DOCDB_ENGINE_VERSION
  DOCDB_INSTANCE_CLASS   = var.DOCDB_INSTANCE_CLASS
  DOCDB_INSTANCE_COUNT   = var.DOCDB_INSTANCE_COUNT
  DOCDB_PG_FAMILY        = var.DOCDB_PG_FAMILY
  DOCDB_PORT             = var.DOCDB_PORT
  VPC_ID                 = module.vpc.VPC_ID
  PRIVATE_SUBNET_ID      = module.vpc.PRIVATE_SUBNET_ID
  ALLOW_SG_CIDR          = concat( module.vpc.PRIVATE_SUBNET_CIDR, tolist([var.WORKSTATION_IP]))
}

module "elasticache" {
  source = "github.com/devopsravi9/module-elasticache"
  PROJECT                    = var.PROJECT
  ENV                        = var.ENV
  ELASTICACHE_ENGINE         = var.ELASTICACHE_ENGINE
  ELASTICACHE_ENGINE_VERSION = var.ELASTICACHE_ENGINE_VERSION
  ELASTICACHE_INSTANCE_CLASS = var.ELASTICACHE_INSTANCE_CLASS
  ELASTICACHE_INSTANCE_COUNT = var.ELASTICACHE_INSTANCE_COUNT
  ELASTICACHE_PG_FAMILY      = var.ELASTICACHE_PG_FAMILY
  ELASTICACHE_PORT           = var.ELASTICACHE_PORT
  VPC_ID                     = module.vpc.VPC_ID
  PRIVATE_SUBNET_CIDR        = module.vpc.PRIVATE_SUBNET_CIDR
  PRIVATE_SUBNET_ID          = module.vpc.PRIVATE_SUBNET_ID
}

module "rabbitmq" {
  source = "github.com/devopsravi9/module-rabbitmq"
  PROJECT                   = var.PROJECT
  ENV                       = var.ENV
  RABBITMQ_INSTANCE_CLASS   = var.RABBITMQ_INSTANCE_CLASS
  RABBITMQ_PORT             = var.RABBITMQ_PORT
  VPC_ID                    = module.vpc.VPC_ID
  PRIVATE_SUBNET_CIDR       = module.vpc.PRIVATE_SUBNET_CIDR
  PRIVATE_SUBNET_ID         = module.vpc.PRIVATE_SUBNET_ID
  WORKSTATION_IP            = var.WORKSTATION_IP
  PRIVATE_ZONE_ID           = var.PRIVATE_ZONE_ID
}

module "lb" {
  source = "github.com/devopsravi9/module-lb"
  PROJECT                   = var.PROJECT
  ENV                       = var.ENV
  VPC_ID                    = module.vpc.VPC_ID
  PUBLIC_SUBNET_ID          = module.vpc.PUBLIC_SUBNET_ID
  PRIVATE_SUBNET_ID         = module.vpc.PRIVATE_SUBNET_ID
  PRIVATE_SUBNET_CIDR       = module.vpc.PRIVATE_SUBNET_CIDR
  PUBLIC_ZONE_ID            = var.PUBLIC_ZONE_ID
}

module "cart" {
  source                  = "github.com/devopsravi9/module-mutable-app"
  COMPONENT               = "cart"
  ENV                     = var.ENV
  INSTANCE_COUNT          = var.INSTANCE_COUNT["CART"]["COUNT"]
  APP_INSTANCE_CLASS      = var.INSTANCE_COUNT["CART"]["INSTANCE_TYPE"]
  APP_PORT                = 8080
  WORKSTATION_IP          = var.WORKSTATION_IP
  PROMETHEUS_IP           = var.PROMETHEUS_IP
  PRIVATE_SUBNET_ID       = module.vpc.PRIVATE_SUBNET_ID
  ALLOW_SG_CIDR           = module.vpc.PRIVATE_SUBNET_CIDR
  VPC_ID                  = module.vpc.VPC_ID
  PRIVATE_LB_ARN          = module.lb.PRIVATE_LB_ARN
  PRIVATE_ZONE_ID         = var.PRIVATE_ZONE_ID
  PUBLIC_LB_ARN           = module.lb.PUBLIC_LB_ARN
  PRIVATE_LB_DNS          = module.lb.PRIVATE_LB_DNS
  PRIVATE_LISTNER_ARN     = module.lb.PRIVATE_LISTNER_ARN
  REDDIS_ENDPOINT         = module.elasticache.REDDIS_ENDPOINT
}

module "catalogue" {
  source                  = "github.com/devopsravi9/module-mutable-app"
  COMPONENT               = "catalogue"
  ENV                     = var.ENV
  INSTANCE_COUNT          = var.INSTANCE_COUNT["CATALOGUE"]["COUNT"]
  APP_INSTANCE_CLASS      = var.INSTANCE_COUNT["CATALOGUE"]["INSTANCE_TYPE"]
  APP_PORT                = 8080
  WORKSTATION_IP          = var.WORKSTATION_IP
  PROMETHEUS_IP           = var.PROMETHEUS_IP
  PRIVATE_SUBNET_ID       = module.vpc.PRIVATE_SUBNET_ID
  ALLOW_SG_CIDR           = module.vpc.PRIVATE_SUBNET_CIDR
  VPC_ID                  = module.vpc.VPC_ID
  PRIVATE_LB_ARN          = module.lb.PRIVATE_LB_ARN
  PRIVATE_ZONE_ID         = var.PRIVATE_ZONE_ID
  PUBLIC_LB_ARN           = module.lb.PUBLIC_LB_ARN
  PRIVATE_LB_DNS          = module.lb.PRIVATE_LB_DNS
  PRIVATE_LISTNER_ARN     = module.lb.PRIVATE_LISTNER_ARN
  DOCDB_ENDPOINT          = module.docdb.DOCDB_ENDPOINT
}

module "user" {
  source                  = "github.com/devopsravi9/module-mutable-app"
  COMPONENT               = "user"
  ENV                     = var.ENV
  INSTANCE_COUNT          = var.INSTANCE_COUNT["USER"]["COUNT"]
  APP_INSTANCE_CLASS      = var.INSTANCE_COUNT["USER"]["INSTANCE_TYPE"]
  APP_PORT                = 8080
  WORKSTATION_IP          = var.WORKSTATION_IP
  PROMETHEUS_IP           = var.PROMETHEUS_IP
  PRIVATE_SUBNET_ID       = module.vpc.PRIVATE_SUBNET_ID
  ALLOW_SG_CIDR           = module.vpc.PRIVATE_SUBNET_CIDR
  VPC_ID                  = module.vpc.VPC_ID
  PRIVATE_LB_ARN          = module.lb.PRIVATE_LB_ARN
  PRIVATE_ZONE_ID         = var.PRIVATE_ZONE_ID
  PUBLIC_LB_ARN           = module.lb.PUBLIC_LB_ARN
  PRIVATE_LB_DNS          = module.lb.PRIVATE_LB_DNS
  PRIVATE_LISTNER_ARN     = module.lb.PRIVATE_LISTNER_ARN
  DOCDB_ENDPOINT          = module.docdb.DOCDB_ENDPOINT
  REDDIS_ENDPOINT         = module.elasticache.REDDIS_ENDPOINT
}

module "payment" {
  source                  = "github.com/devopsravi9/module-mutable-app"
  COMPONENT               = "payment"
  ENV                     = var.ENV
  INSTANCE_COUNT          = var.INSTANCE_COUNT["PAYMENT"]["COUNT"]
  APP_INSTANCE_CLASS      = var.INSTANCE_COUNT["PAYMENT"]["INSTANCE_TYPE"]
  APP_PORT                = 8080
  WORKSTATION_IP          = var.WORKSTATION_IP
  PROMETHEUS_IP           = var.PROMETHEUS_IP
  PRIVATE_SUBNET_ID       = module.vpc.PRIVATE_SUBNET_ID
  ALLOW_SG_CIDR           = module.vpc.PRIVATE_SUBNET_CIDR
  VPC_ID                  = module.vpc.VPC_ID
  PRIVATE_LB_ARN          = module.lb.PRIVATE_LB_ARN
  PRIVATE_ZONE_ID         = var.PRIVATE_ZONE_ID
  PUBLIC_LB_ARN           = module.lb.PUBLIC_LB_ARN
  PRIVATE_LB_DNS          = module.lb.PRIVATE_LB_DNS
  PRIVATE_LISTNER_ARN     = module.lb.PRIVATE_LISTNER_ARN
}

module "shipping" {
  source                  = "github.com/devopsravi9/module-mutable-app"
  COMPONENT               = "shipping"
  ENV                     = var.ENV
  INSTANCE_COUNT          = var.INSTANCE_COUNT["SHIPPING"]["COUNT"]
  APP_INSTANCE_CLASS      = var.INSTANCE_COUNT["SHIPPING"]["INSTANCE_TYPE"]
  APP_PORT                = 8080
  WORKSTATION_IP          = var.WORKSTATION_IP
  PROMETHEUS_IP           = var.PROMETHEUS_IP
  PRIVATE_SUBNET_ID       = module.vpc.PRIVATE_SUBNET_ID
  ALLOW_SG_CIDR           = module.vpc.PRIVATE_SUBNET_CIDR
  VPC_ID                  = module.vpc.VPC_ID
  PRIVATE_LB_ARN          = module.lb.PRIVATE_LB_ARN
  PRIVATE_ZONE_ID         = var.PRIVATE_ZONE_ID
  PUBLIC_LB_ARN           = module.lb.PUBLIC_LB_ARN
  PRIVATE_LB_DNS          = module.lb.PRIVATE_LB_DNS
  PRIVATE_LISTNER_ARN     = module.lb.PRIVATE_LISTNER_ARN
  MYSQL_ENDPOINT          = module.rds.MYSQL_ENDPOINT
}

module "frontend" {
  depends_on = [module.cart, module.catalogue, module.user, module.shipping, module.payment]
  source                  = "github.com/devopsravi9/module-mutable-app"
  COMPONENT               = "frontend"
  ENV                     = var.ENV
  INSTANCE_COUNT          = var.INSTANCE_COUNT["FRONTEND"]["COUNT"]
  APP_INSTANCE_CLASS      = var.INSTANCE_COUNT["FRONTEND"]["INSTANCE_TYPE"]
  APP_PORT                = 80
  WORKSTATION_IP          = var.WORKSTATION_IP
  PROMETHEUS_IP           = var.PROMETHEUS_IP
  PRIVATE_SUBNET_ID       = module.vpc.PRIVATE_SUBNET_ID
  ALLOW_SG_CIDR           = concat(module.vpc.PRIVATE_SUBNET_CIDR, module.vpc.PUBLIC_SUBNET_CIDR)
  VPC_ID                  = module.vpc.VPC_ID
  PUBLIC_LB_ARN           = module.lb.PUBLIC_LB_ARN
  PRIVATE_ZONE_ID         = var.PRIVATE_ZONE_ID
  PRIVATE_LB_ARN          = module.lb.PRIVATE_LB_ARN
  PRIVATE_LB_DNS          = module.lb.PRIVATE_LB_DNS
  PRIVATE_LISTNER_ARN     = module.lb.PRIVATE_LISTNER_ARN
}








