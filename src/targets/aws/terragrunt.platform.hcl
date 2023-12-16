inputs = {
  platform = "aws"

  // TODO this is pretty much invalid config that clashes with requirements of
  // the cloud. find a better way of handling these
  intermediate_crt_b64 = base64encode(file(join("/", [
    local.certs_path,
    "intermediate/tls.crt"
  ])))
  intermediate_key_b64 = base64encode(file(join("/", [
    local.certs_path,
    "intermediate/tls.key"
  ])))
  ca_crt_b64 = base64encode(file(join("/", [
    local.certs_path,
    "intermediate/ca.crt"
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
