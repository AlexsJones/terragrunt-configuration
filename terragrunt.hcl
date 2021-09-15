include {
  path = find_in_parent_folders()
}

locals {
  environment_config = read_terragrunt_config("local_environment.hcl")
  environment = local.environment_config.locals.environment
  # Global config
  terraform_config_file = read_terragrunt_config("terraform_config.hcl")
  terraform_tag_version = local.terraform_config_file.locals.terraform-module-catalogue-tag
}

generate "backend" {
  path = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "remote" {
  hostname = "app.terraform.io"
  organization = "cloud-native-skunkworks"
  token =  get_env("TERRAFORM_WORKSPACE_TOKEN")
    workspaces {
      name = "cloud-native-skunkworks-${local.environment}"
    }
  }
}
EOF
}
