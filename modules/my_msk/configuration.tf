resource "aws_msk_configuration" "kafka_config_general" {
  kafka_versions    = ["${var.kafka_version}"]
  name              = "kafka-config-general"
  server_properties = var.server_properties
}
