terraform {
  backend "remote" {
    organization = "kamz-terraform"
    workspaces {
      name = "mtc-dev-repo"
    }
  }
}