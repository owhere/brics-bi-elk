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
