build {
  sources = [
    "source.amazon-ebs.cassandra"
  ]

  provisioner "shell" {
    script  = "${path.root}/install-node-exporter.sh"
    timeout = "90s"
  }

  provisioner "shell" {
    script  = "${path.root}/install-cassandra.sh"
    timeout = "380s"
  }

  provisioner "shell" {
    script  = "${path.root}/optimize-cassandra.sh"
    timeout = "90s"
  }

  provisioner "shell" {
    script  = "${path.root}/install-cassandra-exporter.sh"
    timeout = "90s"
  }

  provisioner "shell" {
    script  = "${path.root}/install-cassandra-exporter-standalone.sh"
    timeout = "90s"
  }

  provisioner "shell" {
    script  = "${path.root}/install-cqlsh-standalone-tool.sh"
    timeout = "60s"
  }

}
