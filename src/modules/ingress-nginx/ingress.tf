resource "helm_release" "ingress" {
  count      = local.deployment_configs.ingress.count
  name       = var.ingress_nginx_resource_name
  chart      = var.ingress_nginx_resource_chart
  repository = var.ingress_nginx_resource_repository
  version    = var.ingress_nginx_resource_version
  namespace  = local.ingress_namespace
  timeout    = var.helm_timeout_unit
  atomic     = var.helm_atomic

  values = [
    yamlencode({
      controller = {
        # image = {
        #   image    = "k8s-staging-ingress-nginx/controller"
        #   registry = "gcr.io"
        # }

        opentelemetry = {
          enabled = true
          #   image   = "registry.k8s.io/ingress-nginx/opentelemetry:v20230107-helm-chart-4.4.2-2-g96b3d2165@sha256:331b9bebd6acfcd2d3048abbdd86555f5be76b7e3d0b5af4300b04235c6056c9"
          #   containerSecurityContext = {
          #     allowPrivilegeEscalation = false
          # }
        }

        # metrics = {
        #   enabled = true
        # }

        ingressClass = "public"
        ingressClassResource = {
          name    = "public"
          default = true
        }

        config = {
          # enable-opentelemetry = "true"
          opentelemetry-config         = "/etc/nginx/opentelemetry.toml"
          opentelemetry-operation-name = "HTTP $request_method $service_name $uri"
          # opentelemetry-trust-incoming-span = "true"
          otlp-collector-host = "otel-trace-collector.observability"
          otlp-collector-port = "4317"
          # otel-max-queuesize         = "1024"
          # otel-schedule-delay-millis = "5000"
          # otel-max-export-batch-size = "512"
          # otel-service-name          = "ingress-nginx" # Opentelemetry resource name
          otel-sampler       = "AlwaysOn" # Also: AlwaysOff, TraceIdRatioBased
          otel-sampler-ratio = "1.0"
          # otel-sampler-parent-based  = "false"
          # access-log = "false"
          # error-log  = "logs/error.log debug"
          # otlp-collector-host: "tempo.observability.svc"
        }

        extraArgs = {
          default-ssl-certificate = join("/", [
            local.ingress_namespace,
            kubernetes_secret.ingress_server_cert[0].metadata[0].name,
          ])
          # enable-ssl-passthrough = ""
        }
      }
    })
  ]
}
