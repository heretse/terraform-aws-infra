variable "aws_region" {
  description = "aws region"
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "Profile in aws/config"
  default     = ""
}

variable "repo_path" {
  description = "repo path"
  default     = ""
}

locals {
  repos = yamldecode(file("${var.repo_path}"))["repos"]
}
