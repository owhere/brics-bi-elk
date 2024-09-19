# OIDC Variables

variable "oidc_provider_arn" {
  description = "The ARN of the OIDC provider for the EKS cluster."
  type        = string
}

variable "oidc_provider_aud" {
  description = "Audience for the OIDC provider."
  type        = string
  default     = "sts.amazonaws.com"
}

variable "oidc_provider_sub" {
  description = "Subject for the OIDC provider."
  type        = string
}


variable "oidc_issuer_url" {
  description = "The URL of the OIDC issuer for the cluster."
  type        = string
}

# Cluster Variables

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "cluster_role_arn" {
  description = "The ARN of the IAM role for the EKS cluster."
  type        = string
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.30"
}

variable "enabled_cluster_log_types" {
  description = "List of log types to enable for the cluster."
  type        = list(string)
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for encryption."
  type        = string
}


# Networking Variables

variable "subnet_ids" {
  description = "A list of subnet IDs for the EKS cluster."
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs for the EKS cluster."
  type        = list(string)
}

variable "endpoint_private_access" {
  description = "Indicates whether private access to the cluster's Kubernetes API server is enabled."
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Indicates whether public access to the cluster's Kubernetes API server is enabled."
  type        = bool
  default     = false
}

variable "service_ipv4_cidr" {
  description = "The CIDR block for the cluster's service IPs."
  type        = string
}
