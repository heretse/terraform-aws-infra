#!/bin/sh

CLUSTER_NAME="MY-EKS-CLUSTER"

# Create AWSNodeTemplate
cat <<EOF | kubectl apply -f -
---
apiVersion: karpenter.k8s.aws/v1alpha1
kind: AWSNodeTemplate
metadata:
  name: default
spec:
  subnetSelector:                             # required
    karpenter.sh/discovery: ${CLUSTER_NAME}
  securityGroupSelector:                      # required, when not using launchTemplate
    karpenter.sh/discovery: ${CLUSTER_NAME}
  tags:
    eks-cluster: ${CLUSTER_NAME}
  blockDeviceMappings:
    - deviceName: /dev/xvda
      ebs:
        volumeType: gp3
        volumeSize: 20Gi
        deleteOnTermination: true
EOF

## SRE-EKS-ARM-spot ##
cat << EOF | kubectl apply -f -
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: karpenter-arm-spot
spec:
  # References cloud provider-specific custom resource, see your cloud provider specific documentation
  providerRef:
    name: default

  # Provisioned nodes will have these taints
  # Taints may prevent pods from scheduling if they are not tolerated by the pod.
  taints:
    - key: armInstance
      value: 'true'
      effect: PreferNoSchedule

  # Labels are arbitrary key-values that are applied to all nodes
  labels:
    department: sre

  # Annotations are arbitrary key-values that are applied to all nodes
  annotations:
    example.com/owner: "my-team"

  # Enables consolidation which attempts to reduce cluster cost by both removing un-needed nodes and down-sizing those
  # that can't be removed.  Mutually exclusive with the ttlSecondsAfterEmpty parameter.
  consolidation:
    enabled: true

  # If omitted, the feature is disabled, nodes will never scale down due to low utilization
  ttlSecondsUntilExpired: 2592000 # 30 Days = 60 * 60 * 24 * 30 Seconds;

  # Requirements that constrain the parameters of provisioned nodes.
  requirements:
    - key: "alpha.eksctl.io/nodegroup-name"
      operator: In
      values: ["Karpenter-ARM-spot"]
    - key: "node.kubernetes.io/instance-type"
      operator: In
      values: ["t4g.small"]
    - key: "karpenter.sh/capacity-type" # Defaults to on-demand
      operator: In
      values: ["spot"]
    - key: "kubernetes.io/arch"
      operator: In
      values: ["arm64"]
    - key: "nth/enabled"
      operator: In
      values: ["true"]
    - key: "eks-cluster"
      operator: In
      values: [${CLUSTER_NAME}]

  # Resource limits constrain the total size of the cluster.
  # Limits prevent Karpenter from creating new instances once the limit is exceeded.
  limits:
    resources:
      cpu: 24
      memory: 96Gi

  # Karpenter provides the ability to specify a few additional Kubelet args.
  # These are all optional and provide support for additional customization and use cases.
  kubeletConfiguration:
    maxPods: 110
EOF
