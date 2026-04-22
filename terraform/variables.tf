variable "region" {
  default = "ap-south-2"
}

variable "app_name" {
  default = "my-app"
}

variable "image_url" {
  description = "ECR image URL"
}

variable "container_port" {
  default = 3000
}

variable "create_iam_role" {
  description = "Create new IAM role or use existing"
  type        = bool
  default     = false
}

variable "iam_role_name" {
  description = "Existing IAM role name"
  type        = string
  default     = "ecsTaskExecutionRole"
}
