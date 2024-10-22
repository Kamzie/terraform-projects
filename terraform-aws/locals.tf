# --- Root/locals.tf ---

# Local variable defining the VPC's CIDR block
locals {
  vpc_cidr = "10.123.0.0/16"
}

# Local variable defining security groups for different purposes
locals {
  security_groups = {

    # Security group for public access
    public = {
      name        = "public_sg" # Name of the public security group
      description = "Security Group for Public Access"

      # Ingress rules for allowing traffic
      ingress = {

        # Rule for SSH access (port 22), limited to the IP defined in 'access_ip'
        open = {
          from        = 0
          to          = 0
          protocol    = -1
          cidr_blocks = [var.access_ip]
        }

        # Rule for HTTP access (port 80), open to the entire internet
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        nginx = {
          from        = 8000
          to          = 8000
          protocol    = "TCP"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }

    # Security group for RDS (Relational Database Service) private access
    rds = {
      name        = "rds_sg" # Name of the RDS security group
      description = "Security Group for RDS Private Access"

      # Ingress rule for MySQL traffic (port 3306), limited to the VPC's CIDR block
      ingress = {
        mysql = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr] # Restrict access within the VPC
        }
      }
    }
  }
}
