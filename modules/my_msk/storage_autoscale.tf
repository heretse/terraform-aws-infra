resource "aws_appautoscaling_target" "kafka_storage" {
  max_capacity       = var.kafka_scaling_max_capacity
  min_capacity       = 1
  resource_id        = aws_msk_cluster.kafka.arn
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"
}

resource "aws_appautoscaling_policy" "kafka_scaling_policy" {
  name               = "nxd-kafka-broker-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_msk_cluster.kafka.arn
  scalable_dimension = aws_appautoscaling_target.kafka_storage.scalable_dimension
  service_namespace  = aws_appautoscaling_target.kafka_storage.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "KafkaBrokerStorageUtilization"
    }

    target_value = 80
  }
}
