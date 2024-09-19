resource "aws_kms_key" "brics_bi_etcd_key" {
  description             = "KMS key for encrypting etcd secrets for brics-bi-k8s"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}

# Output the KMS key ARN for reference in other configurations
output "kms_key_arn" {
  value = aws_kms_key.brics_bi_etcd_key.arn
}
