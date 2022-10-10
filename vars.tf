variable VPC_CIDR {}
variable "PROJECT" {}
variable "ENV" {}
variable "PRIVATE_CIDR" {}
variable "PUBLIC_CIDR" {}
variable "AZ" {}
variable "DEFAULT_VPC_ID" {}
variable "DEFAULT_ROUTE_TABLE_ID" {}
variable "DEFAULT_CIDR" {}

//rds
variable "ENGINE" {}
variable "ENGINE_VERSION" {}
variable "INSTANCE_CLASS" {}
variable "RDS_PG_FAMILY" {}
variable "RDS_PORT" {}