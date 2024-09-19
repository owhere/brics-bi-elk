resource "aws_eks_cluster" "brics_bi_k8s" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids

    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = var.kms_key_arn
    }
  }

  oidc {
    identity_provider {
      issuer_url = var.oidc_issuer_url
    }
  }

  depends_on = [
    aws_iam_role.brics_bi_cluster_role
  ]
}

# Output the cluster endpoint and ARN
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.brics_bi_k8s.endpoint
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.brics_bi_k8s.arn
}
