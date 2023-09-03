# KarpenterNodeInstanceProfile
resource "aws_iam_instance_profile" "karpenter_node_instance_profile" {
  name = "KarpenterNodeInstanceProfile-${var.eks_cluster_name}"
  path = "/"
  role = aws_iam_role.karpenter_node_role.name
}

# KarpenterNodeRole
resource "aws_iam_role" "karpenter_node_role" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  managed_policy_arns  = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  max_session_duration = "3600"
  name                 = "KarpenterNodeRole-${var.eks_cluster_name}"
  path                 = "/"
}

# KarpenterControllerPolicy
resource "aws_iam_policy" "karpenter_controller_policy" {
  name = "KarpenterControllerPolicy-${var.eks_cluster_name}"
  path = "/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "ec2:CreateLaunchTemplate",
        "ec2:CreateFleet",
        "ec2:RunInstances",
        "ec2:CreateTags",
        "ec2:TerminateInstances",
        "ec2:DeleteLaunchTemplate",
        "ec2:DescribeLaunchTemplates",
        "ec2:DescribeInstances",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeImages",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeInstanceTypeOfferings",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeSpotPriceHistory",
        "ssm:GetParameter",
        "pricing:GetProducts"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "sqs:DeleteMessage",
        "sqs:GetQueueUrl",
        "sqs:GetQueueAttributes",
        "sqs:ReceiveMessage"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:sqs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${var.eks_cluster_name}"
    },
    {
      "Action": [
        "iam:PassRole"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/KarpenterNodeRole-${var.eks_cluster_name}"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

# KarpenterInterruptionQueue
# KarpenterInterruptionQueuePolicy
resource "aws_sqs_queue" "karpenter_interruption_queue" {
  content_based_deduplication       = "false"
  delay_seconds                     = "0"
  fifo_queue                        = "false"
  kms_data_key_reuse_period_seconds = "300"
  max_message_size                  = "262144"
  message_retention_seconds         = "300"
  name                              = var.eks_cluster_name

  policy = <<POLICY
{
  "Id": "EC2InterruptionPolicy",
  "Statement": [
    {
      "Action": "sqs:SendMessage",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "sqs.amazonaws.com",
          "events.amazonaws.com"
        ]
      },
      "Resource": "arn:aws:sqs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${var.eks_cluster_name}"
    }
  ],
  "Version": "2008-10-17"
}
POLICY

  receive_wait_time_seconds  = "0"
  sqs_managed_sse_enabled    = "true"
  visibility_timeout_seconds = "30"
}

# InstanceStateChangeRule
resource "aws_cloudwatch_event_rule" "karpenter_instance_state_change_rule" {
  event_bus_name = "default"
  event_pattern  = "{\"detail-type\":[\"EC2 Instance State-change Notification\"],\"source\":[\"aws.ec2\"]}"
  is_enabled     = "true"
  name           = "karpenter_${var.eks_cluster_name}-InstanceStateChangeRule"
}

resource "aws_cloudwatch_event_target" "karpenter_instance_state_change_rule_karpenter_interruption_queue_target" {
  arn       = aws_sqs_queue.karpenter_interruption_queue.arn
  rule      = aws_cloudwatch_event_rule.karpenter_instance_state_change_rule.name
  target_id = "KarpenterInterruptionQueueTarget"
}

# RebalanceRule
resource "aws_cloudwatch_event_rule" "karpenter_rebalance_rule" {
  event_bus_name = "default"
  event_pattern  = "{\"detail-type\":[\"EC2 Instance Rebalance Recommendation\"],\"source\":[\"aws.ec2\"]}"
  is_enabled     = "true"
  name           = "karpenter_${var.eks_cluster_name}-RebalanceRule"
}

resource "aws_cloudwatch_event_target" "karpenter_rebalance_rule_karpenter_interruption_queue_target" {
  arn       = aws_sqs_queue.karpenter_interruption_queue.arn
  rule      = aws_cloudwatch_event_rule.karpenter_rebalance_rule.name
  target_id = "KarpenterInterruptionQueueTarget"
}

# ScheduledChangeRule
resource "aws_cloudwatch_event_rule" "karpenter_scheduled_change_rule" {
  event_bus_name = "default"
  event_pattern  = "{\"detail-type\":[\"AWS Health Event\"],\"source\":[\"aws.health\"]}"
  is_enabled     = "true"
  name           = "karpenter_${var.eks_cluster_name}-ScheduledChangeRule"
}

resource "aws_cloudwatch_event_target" "karpenter_scheduled_change_rule_karpenter_interruption_queue_target" {
  arn       = aws_sqs_queue.karpenter_interruption_queue.arn
  rule      = aws_cloudwatch_event_rule.karpenter_scheduled_change_rule.name
  target_id = "KarpenterInterruptionQueueTarget"
}

# SpotInterruptionRule
resource "aws_cloudwatch_event_rule" "karpenter_spot_interruption_rule" {
  event_bus_name = "default"
  event_pattern  = "{\"detail-type\":[\"EC2 Spot Instance Interruption Warning\"],\"source\":[\"aws.ec2\"]}"
  is_enabled     = "true"
  name           = "karpenter_${var.eks_cluster_name}-SpotInterruptionRule"
}

resource "aws_cloudwatch_event_target" "karpenter_spot_interruption_rule_karpenter_interruption_queue_target" {
  arn       = aws_sqs_queue.karpenter_interruption_queue.arn
  rule      = aws_cloudwatch_event_rule.karpenter_spot_interruption_rule.name
  target_id = "KarpenterInterruptionQueueTarget"
}
