data "terraform_remote_state" "kubeconfig" {
  backend = "remote"

  config = {
    organization = "kamz-terraform"
    workspaces = {
      name = "dev"
    }
  }
}