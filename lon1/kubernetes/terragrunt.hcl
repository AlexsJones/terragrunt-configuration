locals {
  terraform_config   = read_terragrunt_config(find_in_parent_folders("terraform_config.hcl"))
  tag                       = local.terraform_config.locals.terraform-module-catalogue-tag
  # Regional configuration
  regional_config   = read_terragrunt_config(find_in_parent_folders("regional_config.hcl"))
  token             = local.regional_config.locals.civotoken
  environment       = local.regional_config.locals.environment
  terraform_token   = get_env("TERRAFORM_WORKSPACE_TOKEN")
}

generate "backend" {
  path = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "remote" {
  hostname = "app.terraform.io"
  organization = "cloud-native-skunkworks"
  token =  "${local.terraform_token}"
    workspaces {
      name = "cloud-native-skunkworks-${local.environment}"
    }
  }
}
EOF
}

terraform {
  source = "git::git@github.com:AlexsJones/terraform-module-catalogue.git//civo/kubernetes?ref=${local.tag}"
}

inputs = {
  civotoken = local.token
  cluster_name = "terragrunt-test-lon1"
  cluster_nodes = 3
  region = local.environment
}