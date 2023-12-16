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
    "ingress-nginx"
  ]

  config_templates = {
    providers = [
      {
        name = "tls"
      }
    ]

    required_providers = [
      {
        name = "tls"
      }
    ]

    vars = [
      {
        name = "helm"
      },
      {
        name = "deployment-config"
      },
      {
        name = "tls-intermediate-cert"
      },
      {
        name = "tls-intermediate-key"
      },
      {
        name = "tld"
      },
      {
        name = "sld"
      },
      {
        name = "observability-subdomains"
      },
      {
        name = "vault-subdomain"
      },
      {
        name = "project-name"
      }
    ]
  }
}
