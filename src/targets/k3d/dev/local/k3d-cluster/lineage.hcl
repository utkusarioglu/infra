locals {
  constants = read_terragrunt_config(join("/", [
    get_repo_root(),
    "constants.repo.hcl"
  ])).locals

  module_hierarchy = local.constants.module_hierarchy
  targets_path     = local.constants.targets_path
  modules_path     = local.constants.modules_path
  module_filenames = local.constants.module_filenames

  target_parts = split(
    "/",
    trimprefix(get_path_from_repo_root(),
    "${local.targets_path}/")
  )
  module_depth         = length(local.target_parts)
  module_ancestors     = slice(local.module_hierarchy, 0, local.module_depth)
  module_and_ancestors = slice(local.module_hierarchy, 0, local.module_depth + 1)
  // module_descendants = slice(
  //   local.module_hierarchy,
  //   local.module_depth,
  //   length(local.module_hierarchy)
  // )
  module_and_descendants = slice(
    local.module_hierarchy,
    local.module_depth,
    length(local.module_hierarchy)
  )
  module_role = local.module_and_descendants[0]

  parents_map = zipmap(
    local.module_and_ancestors,
    flatten(["repo", local.target_parts])
  )

  template_types = local.constants.template_types

  parent_folder_relpaths = {
    for parent_type, parent_name in local.parents_map :
    parent_type =>
    parent_type == "repo"
    ? "."
    : join("/", flatten([
      local.targets_path,
      slice(
        local.target_parts,
        0,
        index(local.module_hierarchy, parent_type)
      )
    ]))
  }

  module_folder_relpaths = merge(
    local.parent_folder_relpaths,
    local.module_role == "target"
    ? {
      module = join("/", [
        local.modules_path,
        basename(get_terragrunt_dir())
        ]
      )
    }
    : {}
  )

  module_abspaths = {
    for parent_type, folder_relpath in local.module_folder_relpaths :
    parent_type => join("/", [
      get_repo_root(),
      folder_relpath,
      local.module_filenames[parent_type]
    ])
  }

  // parent_relpaths = {
  //   for parent_type, parent_name in local.parents_map :
  //   parent_type => contains(local.module_and_descendants, parent_type)
  //   ? "skip"
  //   : join("/", flatten([
  //     local.targets_path,
  //     slice(
  //       local.target_parts,
  //       0,
  //       index(local.module_hierarchy, parent_type)
  //     ),
  //     "terragrunt.${parent_type}.hcl"
  //   ]))
  // }

  // parents_new = {
  //   sample = read_terragrunt_config(local.module_abspaths["target"]),
  // }

  module_reads = merge({
    for module_name, module_path in local.module_abspaths :
    module_name => module_name == "target" ? null : module_path
  })

  debug_output = local.module_reads

  parents = {
    for module_type, module_abspath in local.module_reads :
    module_type => module_abspath == null
    ? null
    : read_terragrunt_config(module_abspath)
  }

  // parents = {
  //   repo        = read_terragrunt_config(local.module_abspaths["repo"])
  //   platform    = read_terragrunt_config(local.module_abspaths["platform"])
  //   environment = read_terragrunt_config(local.module_abspaths["environment"])
  //   region      = read_terragrunt_config(local.module_abspaths["region"])
  //   // target      = read_terragrunt_config(local.module_abspaths["target"])
  //   module = read_terragrunt_config(local.module_abspaths["module"])
  //   // for parent_type, parent_abspath in local.module_abspaths :
  //   // parent_type => parent_type == "target"
  //   // ? null
  //   // : read_terragrunt_config(parent_abspath)
  // }

  // parents = merge({
  //   for parent_type, parent_name in local.parents_map :
  //   parent_type => contains(local.module_and_descendants, parent_type)
  //   ? null
  //   : read_terragrunt_config(
  //     find_in_parent_folders("terragrunt.${parent_type}.hcl")
  //   )
  //   },

  //   local.module_role == "target"
  //   ? {
  //     module = read_terragrunt_config(join("/", [
  //       get_repo_root(),
  //       local.modules_path,
  //       basename(get_terragrunt_dir()),
  //       "terragrunt.module.hcl"
  //       ])
  //     )
  //   }
  //   : {}
  // )
}