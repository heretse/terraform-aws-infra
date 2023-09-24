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
  # Enables consolidation which attempts to reduce cluster cost by both removing un-needed nodes and down-sizing those
  # that can't be removed.  Mutually exclusive with the ttlSecondsAfterEmpty parameter.
  consolidation:
    enabled: true
  ttlSecondsUntilExpired: 2592000
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
  taints:
    - key: spotInstance
      value: 'true'
      effect: PreferNoSchedule
  providerRef:
    name: default
# 6 xlarge or 3 2xlarge
  limits:
    resources:
      cpu: 24
      memory: 48Gi
  taints:
    - key: armInstance
      value: 'true'
      effect: PreferNoSchedule
  # Karpenter provides the ability to specify a few additional Kubelet args.
  # These are all optional and provide support for additional customization and use cases.
  kubeletConfiguration:
    maxPods: 110
EOF
