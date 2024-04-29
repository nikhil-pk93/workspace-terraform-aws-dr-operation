output "env_suffix" {
  value = local.env
}
output "iamprofile" {
    value = local.iamprofile
}
# output "rdsinstancetype" {
#   value = local.rdsinstancetype
# }
# output "ec2instancetype" {
#     value = local.ec2instancetype
# }
# output "ec2keypairname" {
#     value = local.ec2keypairname
# }
# output "elbminnode" {
#     value = local.elbminnode
# }
# output "elbmaxnode" {
#     value = local.elbmaxnode
# }
output "tgalb" {
    value = local.tgalb
}
output "vpc-cidr" {
    value = local.vpc-cidr
}
output "public-subnet-1-cidr" {
    value = local.public-subnet-1-cidr
}
output "public-subnet-2-cidr" {
    value = local.public-subnet-2-cidr
}
output "private-subnet-3-cidr" {
    value = local.private-subnet-3-cidr
}
output "private-subnet-4-cidr" {
    value = local.private-subnet-4-cidr
}
output "private-subnet-5-cidr" {
    value = local.private-subnet-5-cidr
}





## ENV setup for local
locals {
  env="${terraform.workspace}"

  ##IAM access key profile
  iamprofile_env={
      default="projectdr"
      dr-min="projectdr"
      dr-prod="projectdr"
  }
  iamprofile="${lookup(local.iamprofile_env, local.env)}"

#   ##RDS Instance class env
#   rdsinstancetype_env= {
#       default="db.t3.micro"
#       staging="db.t3.micro"
#       default="t3.micro"
#       staging="t3.micro"
#       production="m5.large"
#   }
#   ec2instancetype="${lookup(local.ec2instancetype_env, local.env)}"

#   ## Beanstalk Node Pem File


#   ec2keypairname_env= {
#       default="aws_project_tf_kp_staging"
#       staging="aws_project_tf_kp_staging"
#       production="aws_project_tf_kp_staging"
#   }
#   ec2keypairname="${lookup(local.ec2keypairname_env, local.env)}"



#   ## Beanstalk autoscal node min and max

#   elbminnode_env={
#       default="1"
#       staging="1"
#       production="4"
#   }
#   elbminnode=lookup(local.elbminnode_env,local.env)

#   elbmaxnode_env={
#       default="1"
#       staging="2"
#       production="8"
#   }
#   elbmaxnode=lookup(local.elbmaxnode_env,local.env)

  tg_alb_env={
      default="alb-dr-tg-main"
      dr-min="alb-dr-tg-alb-min"
      dr-prod="alb-dr-tg-alb-prods"
  }
  tgalb=lookup(local.tg_alb_env,local.env)

  vpc-cidr_env={
    default="20.0.0.0/16"
    dr-min="20.0.0.0/16"
    dr-prod="20.0.0.0/16"
  }
  vpc-cidr=lookup(local.vpc-cidr_env, local.env)

  public-subnet-1-cidr_env={
    default="20.0.0.0/24"
    dr-min="20.0.0.0/24"
    dr-prod="20.0.0.0/24"
  }
  public-subnet-1-cidr=lookup(local.public-subnet-1-cidr_env, local.env)

  public-subnet-2-cidr_env={
    default="20.0.1.0/24"
    dr-min="20.0.1.0/24"
    dr-prod="20.0.1.0/24"
  }
  public-subnet-2-cidr=lookup(local.public-subnet-2-cidr_env, local.env)

  private-subnet-3-cidr_env={
    default="20.0.2.0/24"
    dr-min="20.0.2.0/24"
    dr-prod="20.0.2.0/24"
  }
  private-subnet-3-cidr=lookup(local.private-subnet-3-cidr_env, local.env)

  private-subnet-4-cidr_env={
    default="20.0.3.0/24"
    dr-min="20.0.3.0/24"
    dr-prod="20.0.3.0/24"
  }
  private-subnet-4-cidr=lookup(local.private-subnet-4-cidr_env, local.env)
  
  private-subnet-5-cidr_env={
    default="20.0.4.0/24"
    dr-min="20.0.4.0/24"
    dr-prod="20.0.4.0/24"
  }
  private-subnet-5-cidr=lookup(local.private-subnet-5-cidr_env, local.env)


}