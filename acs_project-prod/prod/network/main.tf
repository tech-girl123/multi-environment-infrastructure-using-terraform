# Module to deploy basic networking 
module "vpc-dev" {
  source              = "/home/ec2-user/environment/modules/aws_network"
  env                 = var.env
  vpc_cidr            = var.vpc_cidr
  public_cidr_blocks  = var.public_cidr_blocks
  private_cidr_blocks = var.private_cidr_blocks
  prefix              = var.prefix
}