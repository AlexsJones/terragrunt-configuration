locals {
  environment_config = read_terragrunt_config("regional_config.hcl")
  environment = local.environment_config.locals.environment
  # Global config
  terraform_config_file = read_terragrunt_config("terraform_config.hcl")
  terraform_tag_version = local.terraform_config_file.locals.terraform-module-catalogue-tag
}