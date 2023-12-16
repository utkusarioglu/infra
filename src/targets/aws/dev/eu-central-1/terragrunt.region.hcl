inputs = {
  deployment_mode   = "all"
  helm_timeout_unit = 600
  helm_atomic       = true

  region            = local.region
  cluster_name      = local.cluster_name
  aws_profile       = local.aws_profile
  region_identifier = local.region_identifier
}

locals {
  region_short = "euc1"
  aws_profile  = "nextjs-grpc-automation"

  lineage = read_terragrunt_config(join("/", [
    path_relative_from_include(),
    "lineage.helper.hcl"
  ]))
  parents = local.lineage.locals.parents
  region  = local.lineage.locals.parents_map[local.lineage.locals.module_role]

  project_name       = local.parents.repo.inputs.project_name
  project_name_short = local.parents.repo.inputs.project_name_short
  platform           = local.parents.platform.inputs.platform
  environment        = local.parents.environment.inputs.environment

  region_identifier = [
    local.project_name_short,
    local.platform,
    local.environment,
    local.region_short
  ]
  cluster_name = join("-", local.region_identifier)

  aws_provider_args = {
    cluster_region     = local.region
    aws_profile        = local.aws_profile
    platform           = local.platform
    environment        = local.environment
    region             = local.region
    region_short       = local.region_short
    metarepo_name      = local.project_name // this may need to be changed
    project_name       = local.project_name
    project_name_short = local.project_name_short
    aws_profile        = local.aws_profile
  }

  config_templates = {
    providers = [
      {
        name = "aws"
        args = local.aws_provider_args
      },
      {
        name = "aws-dns",
        args = local.aws_provider_args
      }
    ]

    required_providers = [
      {
        name = "aws"
      }
    ]
  }
}
