variable "match_comment" { default = "/(?U)(?m)(?s)(^#.*$)/" }
resource "aws_instance" "cassandra" {
  # checkov:skip=CKV2_AWS_41: "Ensure an IAM role is attached to EC2 instance"

  count         = length(var.private_ips)
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type
  monitoring    = true
  private_ip    = var.private_ips[count.index]
  ebs_optimized = true
  key_name      = var.ssh_key_name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.volume_size
    delete_on_termination = false
    encrypted             = false
  }

  vpc_security_group_ids = [aws_security_group.cassandra.id]
  subnet_id              = var.subnet_ids[count.index]

  lifecycle {
    create_before_destroy = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    "Name"               = "Cassandra_ip-${replace(var.private_ips[count.index], "/\\./", "-")}"
    "Prometheus-monitor" = "enabled"
    "Application"        = "cassandra"
  }

  user_data = <<HERE
#!/bin/bash

read -d '' CONTENT << EOF
${replace(templatefile("${path.module}/template/cassandra.yaml.tmpl", {
  cluster_name              = "${var.cluster_name}",
  seeds                     = (length(var.private_ips) < 3) ? "${var.private_ips[0]}" : "${var.private_ips[0]},${var.private_ips[2]}",
  concurrent_reads          = "${var.concurrent_reads}",
  concurrent_writes         = "${var.concurrent_writes}",
  concurrent_counter_writes = "${var.concurrent_counter_writes}",
  memtable_flush_writers    = "${var.memtable_flush_writers}",
  listen_address            = "${var.private_ips[count.index]}",
  broadcast_rpc_address     = "${var.private_ips[count.index]}",
  concurrent_compactors     = "${var.concurrent_compactors}"
}), var.match_comment, "")}
EOF
echo "$CONTENT" > /etc/cassandra/conf/cassandra.yaml

TOKEN=$(curl -s -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" "http://169.254.169.254/latest/api/token")
LOCAL_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)
sed -i.bak "s/^# JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=<public name>\"/JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=$${LOCAL_IP}\"/" /etc/cassandra/conf/cassandra-env.sh
sed -i.bak "s/^    LOCAL_JMX=yes/    LOCAL_JMX=no/" /etc/cassandra/conf/cassandra-env.sh
sed -i.bak "s/^  JVM_OPTS=\"\$JVM_OPTS -Dcom.sun.management.jmxremote.authenticate=true\"/  JVM_OPTS=\"\$JVM_OPTS -Dcom.sun.management.jmxremote.authenticate=false\"/" /etc/cassandra/conf/cassandra-env.sh

systemctl enable cassandra
systemctl restart cassandra.service

echo "Waiting Cassandra to launch on 9042..."

while ! timeout 1 bash -c "echo > /dev/tcp/$${LOCAL_IP}/9042"; do
  sleep 1
done

sleep 15

if [ "$${LOCAL_IP}" = "${var.private_ips[0]}" ]; then
    /opt/cqlsh-astra/bin/cqlsh -u cassandra -p cassandra ${var.private_ips[0]} -e "ALTER USER cassandra WITH PASSWORD '${var.root_password}';"
fi

java -jar /opt/cassandra_exporter_standalone/cassandra-exporter-standalone.jar --cql-address $${LOCAL_IP}:9042 --cql-user=cassandra --cql-password=${var.root_password} &

HERE
}
