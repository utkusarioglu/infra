inputs = {
  platform = "k3d"

  nodes_volumes_root     = get_env("NODES_VOLUMES_ROOT")
  nodes_source_code_root = get_env("NODES_SOURCE_CODE_ROOT")

  // TODO this is pretty much invalid config that clashes with requirements of the cloud.
  // find a better way of handling these
  intermediate_crt_b64 = base64encode(file(join("/", [
    local.certs_path,
    "intermediate/intermediate.crt"
  ])))
  intermediate_key_b64 = base64encode(file(join("/", [
    local.certs_path,
    "intermediate/intermediate.key"
  ])))
  ca_crt_b64 = base64encode(file(join("/", [
    local.certs_path,
    "root/root.crt"
  ])))
}

locals {
  certs_path = "${get_repo_root()}/.certs"
}

retryable_errors = [
  "(?s).*Error installing provider.*tcp.*connection reset by peer.*",
  "(?s).*ssh_exchange_identification.*Connection closed by remote host.*",
  "(?s).*timed out waiting for the condition.*",
  "(?s).*no such host.*",
]
retry_max_attempts       = 10
retry_sleep_interval_sec = 5
