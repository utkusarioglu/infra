locals {
  deployment_config_templates = {
    all = {
      otel_operator = {
        count = 1
      }
      jaeger_operator = {
        count = 1
      }
    }
    none = {
      otel_operator = {
        count = 0
      }
      jaeger_operator = {
        count = 0
      }
    }
  }

  deployment_config_presets = {
    all              = local.deployment_config_templates.all
    no_observability = local.deployment_config_templates.none
    data_workshop = merge(
      local.deployment_config_templates.none,
      {
        jaeger_operator = {
          count = 1
        }
      }
    )
  }

  deployment_configs = local.deployment_config_presets[var.deployment_mode]
}
