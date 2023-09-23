#!/bin/bash
sudo yum install java-1.8.0-openjdk -y

cat <<EOF | sudo tee -a /etc/yum.repos.d/cassandra40x.repo
[cassandra]
name=Apache Cassandra
baseurl=https://www.apache.org/dist/cassandra/redhat/40x/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://www.apache.org/dist/cassandra/KEYS
EOF

sudo yum update -y

# sudo yum install cassandra -y
sudo wget -O /tmp/cassandra.noarch.rpm https://downloads.apache.org/cassandra/redhat/40x/cassandra-4.0.5-1.noarch.rpm
sudo rpm -i --nodeps /tmp/cassandra.noarch.rpm
sudo rm /tmp/cassandra.noarch.rpm

# reload systemd files
sudo systemctl daemon-reload
sudo service cassandra stop

# clear out data
sudo rm -rf /var/lib/cassandra/data/system/*
