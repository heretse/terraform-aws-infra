#!/bin/bash

# Create '/opt/cassandra_exporter' directory
sudo mkdir -p /opt/cassandra_exporter
sudo chmod 0755 /opt/cassandra_exporter

# Download cassandra_exporter.jar
sudo wget -O /opt/cassandra_exporter/cassandra_exporter.jar https://github.com/criteo/cassandra_exporter/releases/download/2.3.8/cassandra_exporter-2.3.8.jar

# Create cassandra_exporter systemd service unit
cat <<EOF | sudo tee -a /etc/systemd/system/cassandra_exporter.service
[Unit]
Description=Cassandra Exporter for Prometheus
After=cassandra.service

[Service]
Type=idle
WorkingDirectory=/opt/cassandra_exporter
ExecStart=/usr/bin/java -jar cassandra_exporter.jar config.yml

[Install]
WantedBy=multi-user.target

EOF
sudo chmod 0644 /etc/systemd/system/cassandra_exporter.service

# Reload systemd
sudo systemctl daemon-reload

# Copy cassandra_exporter config
cat <<EOF | sudo tee -a /opt/cassandra_exporter/config.yml
host: localhost:7199
ssl: False
user:
password:
listenAddress: 0.0.0.0
listenPort: 8080
blacklist:
   # Unaccessible metrics (not enough privilege)
   - java:lang:memorypool:.*usagethreshold.*

   # Leaf attributes not interesting for us but that are presents in many path (reduce cardinality of metrics)
   - .*:999thpercentile
   - .*:95thpercentile
   - .*:fifteenminuterate
   - .*:fiveminuterate
   - .*:durationunit
   - .*:rateunit
   - .*:stddev
   - .*:meanrate
   - .*:mean
   - .*:min

   # Path present in many metrics but uninterresting
   - .*:viewlockacquiretime:.*
   - .*:viewreadtime:.*
   - .*:cas[a-z]+latency:.*
   - .*:colupdatetimedeltahistogram:.*

   # Mostly for RPC, do not scrap them
   - org:apache:cassandra:db:.*

   # columnfamily is an alias for Table metrics in cassandra 3.x
   # https://github.com/apache/cassandra/blob/8b3a60b9a7dbefeecc06bace617279612ec7092d/src/java/org/apache/cassandra/metrics/TableMetrics.java#L162
   #- org:apache:cassandra:metrics:columnfamily:.*

   # Should we export metrics for system keyspaces/tables ?
   - org:apache:cassandra:metrics:[^:]+:system[^:]*:.*

   # Don't scrape us
   - com:criteo:nosql:cassandra:exporter:.*

maxScrapFrequencyInSec:
  50:
    - .*

  # Refresh those metrics only every hour as it is costly for cassandra to retrieve them
  3600:
    - .*:snapshotssize:.*
    - .*:estimated.*
    - .*:totaldiskspaceused:.*

EOF
sudo chmod 0644 /opt/cassandra_exporter/config.yml

# Enable cassandra_exporter service
sudo systemctl enable cassandra_exporter
