resource "vault_auth_backend" "kubernetes" {
  count = local.deployment_configs.vault_config.count
  type  = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  count           = local.deployment_configs.vault_config.count
  backend         = vault_auth_backend.kubernetes[0].path
  kubernetes_host = "https://kubernetes.default:443"
}

resource "vault_kubernetes_auth_backend_role" "services_issuer" {
  depends_on = [
    vault_kubernetes_auth_backend_config.kubernetes[0]
  ]
  backend                          = vault_auth_backend.kubernetes[0].path
  role_name                        = "services-issuer"
  bound_service_account_names      = ["services-issuer"]
  bound_service_account_namespaces = local.deployment_configs.namespaces.for_each
  token_ttl                        = 3600
  token_policies = [
    vault_policy.all["services"].name,
    vault_policy.all["admin"].name
  ]
  audience = null
  # audience = "cert-manager"
}

resource "vault_kubernetes_auth_backend_role" "ms" {
  depends_on = [
    vault_kubernetes_auth_backend_config.kubernetes[0]
  ]
  backend                          = vault_auth_backend.kubernetes[0].path
  role_name                        = "ms"
  bound_service_account_names      = ["ms"]
  bound_service_account_namespaces = ["ms"]
  token_ttl                        = 3600
  token_policies = [
    vault_policy.all["postgres_storage_inflation_ms"].name,
  ]
  audience = null
  # audience = "cert-manager"
}

resource "vault_kubernetes_auth_backend_role" "grafana" {
  depends_on = [
    vault_kubernetes_auth_backend_config.kubernetes[0]
  ]
  backend = vault_auth_backend.kubernetes[0].path
  # role_name                        = "grafana-deployment"
  # bound_service_account_names      = ["grafana-deployment"]
  role_name                        = "grafana"
  bound_service_account_names      = ["grafana"]
  bound_service_account_namespaces = ["observability"]
  token_ttl                        = 3600
  token_policies = [
    # vault_policy.all["postgres_storage_inflation_grafana"].name,
    vault_policy.all["grafana_users"].name,
  ]
  audience = null
  # audience = "cert-manager"
}
