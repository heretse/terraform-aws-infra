# eksctl create iamidentitymapping \
#   --username system:node:{{EC2PrivateDNSName}} \
#   --cluster "${CLUSTER_NAME}" \
#   --arn "arn:aws:iam::${AWS_ACCOUNT_ID}:role/KarpenterNodeRole-${CLUSTER_NAME}" \
#   --group system:bootstrappers \
#   --group system:nodes

data "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  depends_on = [
    var.eks_cluster_endpoint,
    var.eks_ca_certificate
  ]
}

data "aws_iam_policy_document" "karpenter_controller_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:karpenter:karpenter"]
    }

    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(var.eks_oidc_url, "https://", "")}"]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "karpenter_controller_role" {
  name                 = "${var.eks_cluster_name}-karpenter"
  path                 = "/"
  max_session_duration = 3600

  assume_role_policy = join("", data.aws_iam_policy_document.karpenter_controller_assume_role_policy.*.json)

  tags = {
    "alpha.eksctl.io/cluster-name"                = var.eks_cluster_name
    "alpha.eksctl.io/eksctl-version"              = "0.112.0"
    "alpha.eksctl.io/iamserviceaccount-name"      = "karpenter/karpenter"
    "eksctl.cluster.k8s.io/v1alpha1/cluster-name" = var.eks_cluster_name
  }
}

resource "aws_iam_role_policy_attachment" "karpenter_controller_policy_attachment" {
  policy_arn = aws_iam_policy.karpenter_controller_policy.arn
  role       = aws_iam_role.karpenter_controller_role.name
}

resource "kubernetes_service_account" "karpenter" {
  automount_service_account_token = true
  metadata {
    name      = "karpenter"
    namespace = "karpenter"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.karpenter_controller_role.arn
    }
    labels = {
      "app.kubernetes.io/name"       = "karpenter"
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "null_resource" "helm_experimental_oci" {
  triggers = {
    random = uuid()
  }
  provisioner "local-exec" {
    command = <<-EOT
      export HELM_EXPERIMENTAL_OCI=1
    EOT
  }

  depends_on = [
    data.kubernetes_config_map.aws_auth
  ]
}

resource "helm_release" "karpenter" {
  name             = "karpenter"
  repository       = "oci://public.ecr.aws/karpenter/karpenter"
  chart            = "karpenter"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = var.create_namespace

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_controller_role.name
  }

  set {
    name  = "controller.clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "controller.clusterEndpoint"
    value = var.eks_cluster_endpoint
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter_node_instance_profile.name
  }

  set {
    name  = "settings.aws.interruptionQueueName"
    value = var.eks_cluster_name 
  }

  depends_on = [
    null_resource.helm_experimental_oci,
    var.eks_cluster_endpoint,
    var.eks_ca_certificate
  ]
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    "mapRoles" = <<EOF
${data.kubernetes_config_map.aws_auth.data.mapRoles}
- rolearn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/KarpenterNodeRole-${var.eks_cluster_name}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
EOF
    "mapUsers" = <<EOF
- userarn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:root
  username: admin
  groups:
    - system:masters
EOF
  }

   depends_on = [
    data.kubernetes_config_map.aws_auth
   ]
}
