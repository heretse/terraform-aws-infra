#!/bin/bash

echo "Install CQLSH standalone tool"

# Download CQLSH standalone tool
sudo wget -O /opt/cqlsh-astra.tar.gz https://downloads.datastax.com/enterprise/cqlsh-astra.tar.gz

# Decompress cqlsh-astra.tar.gz
cd /opt
sudo tar xvfz /opt/cqlsh-astra.tar.gz

# Install geomet plugin 
cd /opt/cqlsh-astra/zipfiles/
sudo unzip ./geomet-0.1.0.zip
sudo mv ./geomet-0.1.0/geomet ../pylib/

sudo rm /opt/cqlsh-astra.tar.gz
