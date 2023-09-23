#!/bin/bash

# Create '/opt/cassandra_exporter_standalone' directory
sudo mkdir -p /opt/cassandra_exporter_standalone
sudo chmod 0755 /opt/cassandra_exporter_standalone

# Download cassandra-exporter-standalone.jar
sudo wget -O /opt/cassandra_exporter_standalone/cassandra-exporter-standalone.jar https://github.com/instaclustr/cassandra-exporter/releases/download/v0.9.10/cassandra-exporter-standalone-0.9.10.jar
