resource "aws_iam_role" "bricsbi_eks_ebs_csi_driver_role" {
  name        = "bricsbiEksEbsCsiDriverRole"
  path        = "/"
  description = "EBS CsiDriver Role for brics-bi-k8s"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_provider_arn}:aud" = var.oidc_provider_aud
            "${var.oidc_provider_arn}:sub" = var.oidc_provider_sub
          }
        }
      }
    ]
  })

  max_session_duration = 3600
}

# Attach the required policies for the EBS CSI Driver
resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy" {
  role       = aws_iam_role.bricsbi_eks_ebs_csi_driver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
