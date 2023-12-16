resource "helm_release" "loki" {
  // TODO this is off on kubernetes 1.25 because of podSecurityPolicy deprecation
  # chart             = "loki"
  # repository        = "https://grafana.github.io/helm-charts"
  # version           = "2.13.3"
  count             = local.deployment_configs.loki.count
  name              = "loki"
  chart             = "${var.project_root_abspath}/loki"
  namespace         = "observability"
  dependency_update = true
  cleanup_on_fail   = true
  force_update      = true

  # timeout = var.helm_timeout_unit * 3
  timeout = var.helm_timeout_unit / 2

  atomic = var.helm_atomic
}
