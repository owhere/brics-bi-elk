variable "aws_region" {
  description = "AWS region for the EKS cluster"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_role_arn" {
  description = "IAM role arn for the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.26"
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN"
  type        = string
}

variable "oidc_provider_aud" {
  description = "OIDC audience claim for the EKS cluster"
  type        = string
  default     = "sts.amazonaws.com"
}

variable "oidc_issuer_url" {
  description = "OIDC audience claim for the EKS cluster"
  type        = string 
}

variable "oidc_provider_sub" {
  description = "OIDC Provider SUB"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the EKS cluster"
  type        = list(string)
}

variable "endpoint_private_access" {
  description = "Enable private endpoint access for the EKS cluster"
  type        = bool
  default     = false
}

variable "endpoint_public_access" {
  description = "Enable public endpoint access for the EKS cluster"
  type        = bool
  default     = true
}

variable "service_ipv4_cidr" {
  description = "CIDR block for Kubernetes services"
  type        = string
  default     = "10.100.0.0/16"
}

variable "enabled_cluster_log_types" {
  description = "List of cluster log types to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator"]
}

variable "kms_key_arn" {
  description = "KMS key ARN for encryption"
  type        = string
}
