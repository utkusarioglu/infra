cluster_version         = "1.24"
autoscaling_average_cpu = 30

eks_managed_node_groups = {
  postgres_nodes = {
    ami_type     = "AL2_x86_64"
    min_size     = 1
    max_size     = 1
    desired_size = 1
    instance_types = [
      "t3.medium",
    ]
    capacity_type = "ON_DEMAND"
    network_interfaces = [{
      delete_on_termination       = true
      associate_public_ip_address = true
    }]
    labels = {
      "postgres-storage.ms/dumps-mounted" = "true"
      component                           = "server"
    }
    annotations = {
      "postgres-storage.ms/dumps-mounted" = "true"
    }
  }

  vault_nodes = {
    ami_type     = "AL2_x86_64"
    min_size     = 3
    max_size     = 3
    desired_size = 3
    instance_types = [
      "t3.medium",
    ]
    capacity_type = "ON_DEMAND"
    network_interfaces = [{
      delete_on_termination       = true
      associate_public_ip_address = true
    }]
    labels = {
      vault_in_k8s = "true"
      component    = "server"
    }
    annotations = {
      vault_in_k8s = "true"
    }
    # iam_role_additional_policies = {
    #   additional = aws_iam_policy.vault_kms_unseal.arn
    # }
    # block_device_mappings = {
    #   xvdf = {
    #     device_name = "/dev/xvdf"
    #     ebs = {
    #       volume_size = 50
    #       volume_type = "gp2"
    #       # iops        = 3000
    #       # throughput  = 150
    #     }
    #   }
    # }
  }

  regular_nodes = {
    ami_type     = "AL2_x86_64"
    min_size     = 2
    max_size     = 2
    desired_size = 2
    instance_types = [
      "t3.small",
      # "t3.medium",
      # "t3.large",
      # "t3a.small",
      # "t3a.medium",
      # "t3a.large"
    ]
    capacity_type = "SPOT"
    network_interfaces = [{
      delete_on_termination       = true
      associate_public_ip_address = true
    }]
    # labels = {
    # vault_in_k8s = true
    # }
  }
  # "my-app-eks-arm" = {
  #   ami_type     = "AL2_ARM_64"
  #   min_size     = 1
  #   max_size     = 16
  #   desired_size = 1
  #   instance_types = [
  #     "c7g.medium",
  #     "c7g.large"
  #   ]
  #   capacity_type = "ON_DEMAND"
  #   network_interfaces = [{
  #     delete_on_termination       = true
  #     associate_public_ip_address = true
  #   }]
  # }
}
