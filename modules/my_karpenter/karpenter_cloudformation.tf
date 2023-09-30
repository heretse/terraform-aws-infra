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

  managed_policy_arns = [
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
  # checkov:skip=CKV_AWS_288: "Ensure IAM policies does not allow data exfiltration"
  # checkov:skip=CKV_AWS_355: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"

  name = "KarpenterControllerPolicy-${var.eks_cluster_name}"
  path = "/"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowScopedEC2InstanceActions",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:ec2:${var.aws_region}::image/*",
        "arn:aws:ec2:${var.aws_region}::snapshot/*",
        "arn:aws:ec2:${var.aws_region}:*:spot-instances-request/*",
        "arn:aws:ec2:${var.aws_region}:*:security-group/*",
        "arn:aws:ec2:${var.aws_region}:*:subnet/*",
        "arn:aws:ec2:${var.aws_region}:*:launch-template/*"
      ],
      "Action": [
        "ec2:RunInstances",
        "ec2:CreateFleet"
      ]
    },
    {
      "Sid": "AllowScopedEC2LaunchTemplateActions",
      "Effect": "Allow",
      "Resource": "arn:aws:ec2:${var.aws_region}:*:launch-template/*",
      "Action": "ec2:CreateLaunchTemplate",
      "Condition": {
        "StringEquals": {
          "aws:RequestTag/kubernetes.io/cluster/${var.eks_cluster_name}": "owned"
        },
        "StringLike": {
          "aws:RequestTag/karpenter.sh/provisioner-name": "*"
        }
      }
    },
    {
      "Sid": "AllowScopedEC2InstanceActionsWithTags",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:ec2:${var.aws_region}:*:fleet/*",
        "arn:aws:ec2:${var.aws_region}:*:instance/*",
        "arn:aws:ec2:${var.aws_region}:*:volume/*",
        "arn:aws:ec2:${var.aws_region}:*:network-interface/*"
      ],
      "Action": [
        "ec2:RunInstances",
        "ec2:CreateFleet"
      ],
      "Condition": {
        "StringEquals": {
          "aws:RequestTag/kubernetes.io/cluster/${var.eks_cluster_name}": "owned"
        },
        "StringLike": {
          "aws:RequestTag/karpenter.sh/provisioner-name": "*"
        }
      }
    },
    {
      "Sid": "AllowScopedResourceCreationTagging",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:ec2:${var.aws_region}:*:fleet/*",
        "arn:aws:ec2:${var.aws_region}:*:instance/*",
        "arn:aws:ec2:${var.aws_region}:*:volume/*",
        "arn:aws:ec2:${var.aws_region}:*:network-interface/*",
        "arn:aws:ec2:${var.aws_region}:*:launch-template/*"
      ],
      "Action": "ec2:CreateTags",
      "Condition": {
        "StringEquals": {
          "aws:RequestTag/kubernetes.io/cluster/${var.eks_cluster_name}": "owned",
          "ec2:CreateAction": [
            "RunInstances",
            "CreateFleet",
            "CreateLaunchTemplate"
          ]
        },
        "StringLike": {
          "aws:RequestTag/karpenter.sh/provisioner-name": "*"
        }
      }
    },
    {
      "Sid": "AllowMachineMigrationTagging",
      "Effect": "Allow",
      "Resource": "arn:aws:ec2:${var.aws_region}:*:instance/*",
      "Action": "ec2:CreateTags",
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/kubernetes.io/cluster/${var.eks_cluster_name}": "owned",
          "aws:RequestTag/karpenter.sh/managed-by": "${var.eks_cluster_name}"
        },
        "StringLike": {
          "aws:RequestTag/karpenter.sh/provisioner-name": "*"
        },
        "ForAllValues:StringEquals": {
          "aws:TagKeys": [
            "karpenter.sh/provisioner-name",
            "karpenter.sh/managed-by"
          ]
        }
      }
    },
    {
      "Sid": "AllowScopedDeletion",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:ec2:${var.aws_region}:*:instance/*",
        "arn:aws:ec2:${var.aws_region}:*:launch-template/*"
      ],
      "Action": [
        "ec2:TerminateInstances",
        "ec2:DeleteLaunchTemplate"
      ],
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/kubernetes.io/cluster/${var.eks_cluster_name}": "owned"
        },
        "StringLike": {
          "aws:ResourceTag/karpenter.sh/provisioner-name": "*"
        }
      }
    },
    {
      "Sid": "AllowRegionalReadActions",
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeImages",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceTypeOfferings",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeLaunchTemplates",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSpotPriceHistory",
        "ec2:DescribeSubnets"
      ],
      "Condition": {
        "StringEquals": {
          "aws:RequestedRegion": "${var.aws_region}"
        }
      }
    },
    {
      "Sid": "AllowGlobalReadActions",
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "pricing:GetProducts",
        "ssm:GetParameter"
      ]
    },
    {
      "Sid": "AllowInterruptionQueueActions",
      "Effect": "Allow",
      "Resource": "${aws_sqs_queue.karpenter_interruption_queue.arn}",
      "Action": [
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:GetQueueUrl",
        "sqs:ReceiveMessage"
      ]
    },
    {
      "Sid": "AllowPassingInstanceRole",
      "Effect": "Allow",
      "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/KarpenterNodeRole-${var.eks_cluster_name}",
      "Action": "iam:PassRole",
      "Condition": {
        "StringEquals": {
          "iam:PassedToService": "ec2.amazonaws.com"
        }
      }
    },
    {
      "Sid": "AllowAPIServerEndpointDiscovery",
      "Effect": "Allow",
      "Resource": "arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${var.eks_cluster_name}",
      "Action": "eks:DescribeCluster"
    }
  ]
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
