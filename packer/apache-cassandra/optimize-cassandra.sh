#!/bin/bash

# Set user resource limits
cat <<EOF | sudo tee -a /etc/sysctl.conf
vm.max_map_count=1048575

EOF

# TCP settings
cat <<EOF | sudo tee -a /etc/sysctl.conf
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.rmem_default = 16777216
net.core.wmem_default = 16777216
net.core.optmem_max = 40960
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216

EOF
sudo sysctl -p /etc/sysctl.conf

# Disable swap
sudo swapoff --all
