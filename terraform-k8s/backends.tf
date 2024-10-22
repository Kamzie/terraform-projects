terraform {
  cloud {

    organization = "kamz-terraform"

    workspaces {
      name = "k8s"
    }
  }
}