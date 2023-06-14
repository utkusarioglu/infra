terraform {
  source = join("/", [
    get_repo_root(),
    "src/modules/",
    basename(get_terragrunt_dir())
  ])

  extra_arguments "required_var_files" {
    commands = [
      "apply",
      "plan",
      "destroy",
    ]
    required_var_files = [
      for file in local.required_var_files :
      "${get_repo_root()}/vars/${file}.tfvars"
    ]
  }
}

locals {
  required_var_files = [
    "aws-spot-termination-handler",
    "aws-external-dns",
    "aws-vpc", // for `name_prefix only
    "aws-iam",
    "aws-ingress"
  ]

  config_templates = {
    data = [
      {
        name = "aws-caller-identity"
      }
    ]
    vars = [
      {
        name = "cluster"
      }
      // {
      //   name = "project"
      // },
    ],
  }
}

generate "generated_config_module" {
  path      = "generated-config.module.tf"
  if_exists = "overwrite"
  contents = join("\n", ([
    for key, items in local.config_templates :
    (join("\n", [
      for j, template in items :
      templatefile(
        "${get_repo_root()}/src/templates/${key}/${template.name}.tftpl.hcl",
        try(template.args, {})
      )
    ]))
  ]))
}
