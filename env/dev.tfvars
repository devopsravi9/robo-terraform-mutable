ENV                     = "dev"
PROJECT                 = "roboshop"

//VPC
VPC_CIDR                = "10.50.0.0/16"
PUBLIC_CIDR             = [ "10.50.0.0/24", "10.50.1.0/24"]
PRIVATE_CIDR            = [ "10.50.2.0/24", "10.50.3.0/24"]
AZ                      = ["us-east-1a", "us-east-1b"]
DEFAULT_VPC_ID          = "vpc-0ee467a809c645459"
DEFAULT_CIDR            = "172.31.0.0/16"
DEFAULT_ROUTE_TABLE_ID  = "rtb-019135e82660af7cb"

//rds
ENGINE                  = "mysql"
ENGINE_VERSION          = "5.7"
INSTANCE_CLASS          = "db.t3.micro"
RDS_PG_FAMILY           = "mysql5.7"
RDS_PORT                = 3306