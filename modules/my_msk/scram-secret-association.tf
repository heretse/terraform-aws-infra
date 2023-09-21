

resource "aws_secretsmanager_secret" "kafka_secrets" {
  for_each   = { for user in var.msk_users : user.username => user }
  name       = "AmazonMSK_${each.value.username}"
  kms_key_id = aws_kms_key.kafka_key.key_id
}

resource "aws_kms_key" "kafka_key" {
  description = "Example Key for MSK Cluster Scram Secret Association"
}

resource "aws_secretsmanager_secret_version" "kafka_secrets" {
  for_each      = { for user in var.msk_users : user.username => user }
  secret_id     = aws_secretsmanager_secret.kafka_secrets["${each.value.username}"].id
  secret_string = jsonencode({ username : "${each.value.username}", password : "${each.value.password}" })

  depends_on = [
    aws_secretsmanager_secret.kafka_secrets
  ]
}

resource "aws_secretsmanager_secret_policy" "kafka_secrets" {
  for_each   = { for user in var.msk_users : user.username => user }
  secret_arn = aws_secretsmanager_secret.kafka_secrets["${each.value.username}"].arn
  policy     = <<POLICY
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Sid": "AWSKafkaResourcePolicy",
    "Effect" : "Allow",
    "Principal" : {
      "Service" : "kafka.amazonaws.com"
    },
    "Action" : "secretsmanager:getSecretValue",
    "Resource" : "${aws_secretsmanager_secret.kafka_secrets["${each.value.username}"].arn}"
  } ]
}
POLICY

  depends_on = [
    aws_secretsmanager_secret.kafka_secrets
  ]
}
resource "aws_msk_scram_secret_association" "kafka" {
  cluster_arn = aws_msk_cluster.kafka.arn
  secret_arn_list = flatten([
    for user in var.msk_users :
    "${aws_secretsmanager_secret.kafka_secrets["${user.username}"].arn}"
  ])

  depends_on = [aws_secretsmanager_secret_version.kafka_secrets]
}
