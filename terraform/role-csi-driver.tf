resource "aws_iam_role" "bricsbi_eks_ebs_csi_driver_role" {
  name        = "bricsbiEksEbsCsiDriverRole"
  path        = "/"
  description = "EBS CsiDriver Role for brics-bi-k8s"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          # 1) Use the FULL ARN for the principal
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            # 2) Use the domain path for these keys
            "${var.oidc_provider_url}:sub" = var.oidc_provider_sub
            "${var.oidc_provider_url}:aud" = var.oidc_provider_aud
          }
        }
      }
    ]
  })

  max_session_duration = 3600
}

# Then attach the EBS CSI policy
resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy" {
  role       = aws_iam_role.bricsbi_eks_ebs_csi_driver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
