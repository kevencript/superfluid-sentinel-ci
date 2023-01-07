module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = var.vpc_cidr
  vpc_name       = var.vpc_name
}