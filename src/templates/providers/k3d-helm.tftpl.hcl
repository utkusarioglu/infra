provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "k3d-${cluster_name}"
  }
  // experiments {
  //   manifest = true
  // }
}
