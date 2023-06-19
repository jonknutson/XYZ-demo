variable "K8S_USER_ARN" {
  type        = string
  description = "IAM User to add to aws-auth ConfigMap"
}

variable "PIPELINE_ROLE" {
  type        = string
  description = "Role to add to aws-auth ConfigMap"
}