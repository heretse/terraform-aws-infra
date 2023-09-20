variable "aws_region" {
  description = "AWS region"
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "AWS profile"
  default     = ""
}

variable "eventbridge_path" {
  type        = string
  description = "The path of configuration file"
}
