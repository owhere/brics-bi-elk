resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.brics_bi_k8s.name
  node_group_name = "default-node-group"
  node_role_arn   = aws_iam_role.brics_bi_node_group_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  instance_types = ["t3.medium"] # Replace with your preferred instance types
  disk_size      = 20           # Disk size in GB

  ami_type = "AL2_x86_64" # Amazon Linux 2 for EKS

  tags = {
    "Environment" = "Development"
    "Name"        = "brics-bi-node-group"
  }
}
