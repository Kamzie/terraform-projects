# --- Root/backends.tf ---
terraform {
  cloud {

    organization = "kamz-terraform"

    workspaces {
      name = "dev"
    }
  }
}

