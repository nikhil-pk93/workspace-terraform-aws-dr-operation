provider "aws" {
 region     = "me-south-1"

 profile = "${module.shared_vars.iamprofile}"
}

## Loading each module

module "vpc_module" {
   source = "./vpc_module"  
}
module "tg_module" {
   vpcdr="${module.vpc_module.vpcdr}"
   alb_arn="${module.alb_module.alb_arn}"
   source = "./tg_module"  
}


module "alb_module" {
  publicsg1="${module.vpc_module.publicsg1}"
  publicsg2="${module.vpc_module.publicsg2}"
  vpcdr="${module.vpc_module.vpcdr}"
  tg_arn="${module.tg_module.tg_arn}"
  source = "./alb_module"
}

# module "nlb_module" {
#   publicsg1="${module.vpc_module.publicsg1}"
#   publicsg2="${module.vpc_module.publicsg2}"
#   tg_arn_nlb_80="${module.tg_module.tg_arn_nlb_80}"
#   tg_arn_nlb_443="${module.tg_module.tg_arn_nlb_443}"
#   source = "./nlb_module"  
# }

module "launchandASG_module"{
  publicsg1="${module.vpc_module.publicsg1}"
  publicsg2="${module.vpc_module.publicsg2}"
  privatesg1="${module.vpc_module.privatesg1}"
  privatesg2="${module.vpc_module.privatesg2}"
  privatesg3="${module.vpc_module.privatesg3}"
  tg_arn="${module.tg_module.tg_arn}"
  vpcdr="${module.vpc_module.vpcdr}"
  source = "./launchandASG_module"
}

# module "rds_module" {
#   publicsg1="${module.vpc_module.publicsg1}"
#   publicsg2="${module.vpc_module.publicsg2}"
#   node-sec="${module.launchandASG_module.node-sec}"
#   vpcdr="${module.vpc_module.vpcdr}"
#   source = "./rds_module"
# }

# module "waf_module" {
#   alb_arn="${module.alb_module.alb_arn}"
#   source = "./waf_module"
# }


module "shared_vars" {
  source = "./shared_vars"
}

##Storing terraform state to S3

terraform {
backend "s3" {
      bucket         = "drsultan-terraform-state"
      key            = "drsultan/terraform.tfstate"
      region         = "eu-west-1"
      profile        = "drsultan"     
}
}