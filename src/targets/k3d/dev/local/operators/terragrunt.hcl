include "region" {
  path = find_in_parent_folders("terragrunt.region.hcl")
}

include "module" {
  path = join("/", [
    get_repo_root(),
    "src/modules/",
    basename(get_terragrunt_dir()),
    "terragrunt.module.hcl"
  ])
}

include "logic" {
  path = "./logic.target.k3d.hcl"
}

dependencies {
  paths = [
    "../k3d-cluster",
    "../k8s-namespaces",
    "../k8s-config"
  ]
}
