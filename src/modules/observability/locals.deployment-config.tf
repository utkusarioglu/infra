locals {
  deployment_config_templates = {
    all = {
      grafana = {
        count = 1
      }
      jaeger = {
        count = 1
      }
      loki = {
        count = 1
      }
      otel_collectors = {
        count = 1
      }
      prometheus = {
        count = 1
      }
      kubernetes_dashboard = {
        count = 1
      }
    }

    none = {
      grafana = {
        count = 0
      }
      jaeger = {
        count = 0
      }
      loki = {
        count = 0
      }
      otel_collectors = {
        count = 0
      }
      prometheus = {
        count = 0
      }
      kubernetes_dashboard = {
        count = 0
      }
    }
    data_workshop = {
      grafana = {
        count = 0
      }
      jaeger = {
        count = 1
      }
      loki = {
        count = 0
      }
      otel_collectors = {
        count = 0
      }
      prometheus = {
        count = 0
      }
      kubernetes_dashboard = {
        count = 0
      }
    }
  }

  deployment_config_presets = {
    all              = local.deployment_config_templates.all
    no_observability = local.deployment_config_templates.none
    data_workshop    = local.deployment_config_templates.data_workshop
    grafana = merge(
      local.deployment_config_templates.none,
      {
        grafana = {
          count = 1
        }
      }
    )
  }

  deployment_configs = local.deployment_config_presets[var.deployment_mode]
}
