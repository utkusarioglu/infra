# TODO upgrade
dns_base_domain = "utkusarioglu.com"

# if you change this, dont forget to change the provisioner inside 
# ingress.config.tf helm_release.ingress_gateway
ingress_gateway_name          = "aws-load-balancer-controller"
ingress_gateway_iam_role      = "load-balancer-controller"
ingress_gateway_chart_name    = "aws-load-balancer-controller"
ingress_gateway_chart_repo    = "https://aws.github.io/eks-charts"
ingress_gateway_chart_version = "1.4.1"
