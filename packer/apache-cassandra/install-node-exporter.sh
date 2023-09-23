#!/bin/bash

# Download node_exporter
cd /tmp
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-arm64.tar.gz
sudo tar xvfz node_exporter-1.3.1.linux-arm64.tar.gz

# Move node_exporter to /usr/local/bin
sudo mv ./node_exporter-1.3.1.linux-arm64/node_exporter /usr/local/bin/node_exporter
sudo chmod 0755 /usr/local/bin/node_exporter

# Install node_exporter sysconfig
cat <<EOF | sudo tee -a /etc/sysconfig/node_exporter
OPTIONS="--collector.diskstats --collector.cpu --collector.filesystem --collector.loadavg --collector.meminfo --collector.netdev --collector.stat --collector.time --collector.uname --collector.vmstat --collector.processes --collector.conntrack"

EOF
sudo chmod 0644 /etc/sysconfig/node_exporter
# Install node_exporter systemd file
cat <<EOF | sudo tee -a /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
EnvironmentFile=-/etc/sysconfig/node_exporter
ExecStart=/usr/local/bin/node_exporter $OPTIONS

[Install]
WantedBy=default.target

EOF
sudo chmod 0644 /etc/systemd/system/node_exporter.service

# Reload systemd
sudo systemctl daemon-reload

# Add user "prometheus"
sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus

# Enable node_exporter service
sudo systemctl enable node_exporter
