output "chart" {
  value = join("", helm_release.aws_load_balancer_controller.*.chart)
}

output "repository" {
  value       = join("", helm_release.aws_load_balancer_controller.*.repository)
  description = "Repository URL where to locate the requested chart."
}
output "version" {
  value       = join("", helm_release.aws_load_balancer_controller.*.version)
  description = "Specify the exact chart version to install. If this is not specified, the latest version is installed."
}
