//--------------------------------------------------------------------
// Variables



//--------------------------------------------------------------------
// Modules
module "compute" {
  source  = "app.terraform.io/kamz-terraform/compute/aws"
  version = "1.0.0"

  aws_region          = "eu-west-2"
  public_key_material = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQChRPrVFImiyZqlxfcBhX0uVsA8NSPSYuF17Ay4HgQ10qy0+/GBCk2X1Rgc9u+01qLLy7ZCrzN5qNNxKYhb4NCYkIxFp9yACpkDjsRFQOEWijuWxN3MXzLbBat18SAxIJajNKauNeT1MMiuPSoHVlfXQRZhLPfin4wQrmjpCuVdJylu8cer1p1tmBKISG4LUrIe4aTBkJa0M2yZe2iXU5GrfbJAewSgsFH0OTeQ2jSnyveTLwIHMYCIxjoejfGobm0C6tmlHCWLI0RnqA3WVMDFgeEkpTBpHstCMtZr1J/YzETK9o/iGsG85Ik7930IqJa0Us7pc0tJRcGO2jr0lgwilKf+41vzpX32fPSMemXmzj8VKElUVYI2YHBsVNZDd3WmgoQviLrh/Xs0Oq7Vhu50yxYYEuoxJc9FrPDz0SwvTiRQbiyte5E8DH/21QDu5/ywyqq8R78JtmUIy0hsaHS02w/RA1dejTQZCq9KtO9dWyC/bvie1Vye2VOeY+sRMxc= kamz@kamz-B650E-Taichi-Lite"
  public_sg           = module.networking.public_sg
  public_subnets      = module.networking.public_subnets
}

module "networking" {
  source  = "app.terraform.io/kamz-terraform/networking/aws"
  version = "1.0.0"

  access_ip  = "149.71.231.17/32"
  aws_region = "eu-west-2"
}

