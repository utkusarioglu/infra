resource "kubernetes_storage_class" "data_loki_write" {
  count = 1
  # count = local.deployment_configs.postgres_tablespaces_sc.count
  metadata {
    # name = local.postgres_storage.tablespaces.sc_name
    name = "loki-single-binary"
  }

  storage_provisioner = helm_release.host_volumes_provisioner[0].name
  reclaim_policy      = "Delete"
  volume_binding_mode = "Immediate"
  parameters = {
    nodePath = var.nodes_volumes_root
  }
  mount_options = [
    "file_mode=0700",
    "dir_mode=0777",
    "mfsymlinks",
    "uid=1001",
    "gid=0",
    "nobrl",
    "cache=none"
  ]

  allowed_topologies {
    match_label_expressions {
      key = "loki-single-binary.observability/target-volume"
      values = [
        "true"
      ]
    }
  }
}
