resource "helm_release" "grafana" {
  // TODO this is off on kubernetes 1.25 because of podSecurityPolicy deprecation
  count             = local.deployment_configs.grafana.count
  name              = "grafana"
  chart             = "${var.project_root_abspath}/grafana"
  dependency_update = true
  namespace         = "observability"
  timeout           = var.helm_timeout_unit
  atomic            = var.helm_atomic
  # recreate_pods     = true

  values = [
    yamlencode({
      grafana = {
        ingress = {
          annotations = {
            "kubernetes.io/ingress.class"               = local.ingress_class_mapping[var.platform]
            "alb.ingress.kubernetes.io/security-groups" = var.ingress_sg
            "external-dns.alpha.kubernetes.io/hostname" = local.grafana_url
          }
          hosts = [
            local.grafana_url
          ]
          # TODO these are probably deprecated, remove them
          # ingressClassName = local.ingress_class_mapping[var.platform]
          # host             = local.grafana_url
        }
        service = {
          type = local.ingress_service_types[var.platform]
        }
      }
    })
  ]
}

# resource "helm_release" "grafana" {
#   // TODO this is off on kubernetes 1.25 because of podSecurityPolicy deprecation
#   count             = local.deployment_configs.grafana.count
#   name              = "grafana"
#   chart             = "${var.project_root_abspath}/grafana"
#   dependency_update = true
#   namespace         = "observability"
#   timeout           = var.helm_timeout_unit
#   atomic            = var.helm_atomic
#   # recreate_pods     = true

#   values = [
#     yamlencode({
#       ingress = {
#         annotations = {
#           "kubernetes.io/ingress.class"               = local.ingress_class_mapping[var.platform]
#           "alb.ingress.kubernetes.io/security-groups" = var.ingress_sg
#           "external-dns.alpha.kubernetes.io/hostname" = local.grafana_url
#         }
#         ingressClassName = local.ingress_class_mapping[var.platform]
#         host             = local.grafana_url
#       }
#       service = {
#         type = local.ingress_service_types[var.platform]
#       }
#     })
#   ]
#   # values = [
#   #   yamlencode({
#   #     grafana = {
#   #       ingress = {
#   #         annotations = {
#   #           "kubernetes.io/ingress.class"               = local.ingress_class_mapping[var.platform]
#   #           "alb.ingress.kubernetes.io/security-groups" = var.ingress_sg
#   #           "external-dns.alpha.kubernetes.io/hostname" = local.grafana_url
#   #         }
#   #         hosts = [
#   #           local.grafana_url
#   #         ]
#   #       }
#   #       service = {
#   #         type = local.ingress_service_types[var.platform]
#   #       }
#   #     }
#   #   })
#   # ]

#   # set {
#   #   name  = "grafana.ingress.hosts"
#   #   value = "{${local.grafana_url}}"
#   # }

#   # set {
#   #   name  = "grafana.ingress.annotations.${replace("kubernetes.io/ingress.class", ".", "\\.")}"
#   #   value = local.ingress_class_mapping[var.platform]
#   # }

#   # set {
#   #   name  = "grafana.ingress.annotations.${replace("alb.ingress.kubernetes.io/security-groups", ".", "\\.")}"
#   #   value = var.ingress_sg
#   # }

#   # set {
#   #   name  = "grafana.ingress.annotations.${replace("external-dns.alpha.kubernetes.io/hostname", ".", "\\.")}"
#   #   value = local.grafana_url
#   # }

#   # set {
#   #   name  = "grafana.service.type"
#   #   value = local.ingress_service_types[var.platform]
#   # }
# }

# # resource "helm_release" "grafana" {
# #   // TODO this is off on kubernetes 1.25 because of podSecurityPolicy deprecation
# #   count             = local.deployment_configs.grafana.count
# #   name              = "grafana"
# #   chart             = "${var.project_root_abspath}/grafana"
# #   dependency_update = true
# #   namespace         = "observability"
# #   timeout           = var.helm_timeout_unit
# #   atomic            = var.helm_atomic
# #   recreate_pods     = true

# # values = [
# #   yamlencode({
# #     grafana = {
# #       ingress = {
# #         annotations = {
# #           "kubernetes.io/ingress.class"               = local.ingress_class_mapping[var.platform]
# #           "alb.ingress.kubernetes.io/security-groups" = var.ingress_sg
# #           "external-dns.alpha.kubernetes.io/hostname" = local.grafana_url
# #         }
# #         hosts = [
# #           local.grafana_url
# #         ]
# #       }
# #       service = {
# #         type = local.ingress_service_types[var.platform]
# #       }
# #     }
# #   })
# # ]

# #   set {
# #     name  = "grafana.ingress.hosts"
# #     value = "{${local.grafana_url}}"
# #   }

# #   set {
# #     name  = "grafana.ingress.annotations.${replace("kubernetes.io/ingress.class", ".", "\\.")}"
# #     value = local.ingress_class_mapping[var.platform]
# #   }

# #   set {
# #     name  = "grafana.ingress.annotations.${replace("alb.ingress.kubernetes.io/security-groups", ".", "\\.")}"
# #     value = var.ingress_sg
# #   }

# #   set {
# #     name  = "grafana.ingress.annotations.${replace("external-dns.alpha.kubernetes.io/hostname", ".", "\\.")}"
# #     value = local.grafana_url
# #   }

# #   set {
# #     name  = "grafana.service.type"
# #     value = local.ingress_service_types[var.platform]
# #   }
# # }
