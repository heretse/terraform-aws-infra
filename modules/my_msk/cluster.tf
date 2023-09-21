resource "aws_msk_cluster" "kafka" {
  cluster_name           = var.kafka_cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.kafka_number_of_broker_nodes

  broker_node_group_info {
    instance_type   = var.kafka_instance_type
    client_subnets  = var.kafka_client_subnets
    security_groups = var.kafka_security_groups

    storage_info {
      ebs_storage_info {
        provisioned_throughput {
          enabled = false
        }

        volume_size = var.kafka_ebs_volume_size
      }
    }
  }

  client_authentication {
    sasl {
      scram = true
    }
  }

  configuration_info {
    arn      = aws_msk_configuration.kafka_config_general.arn
    revision = aws_msk_configuration.kafka_config_general.latest_revision
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = var.kafka_log_group_name
      }
    }
  }

  tags = {
    type = "kafkaMSK"
  }

  depends_on = [
    aws_msk_configuration.kafka_config_general
  ]

}
