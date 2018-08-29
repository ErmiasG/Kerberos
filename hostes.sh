#!/bin/bash
set -eux
echo "Hostname config"

cat >> /etc/hosts <<EOF
192.168.10.21  kdc.example.com
192.168.10.22  server.example.com
192.168.10.23  hdp.example.com
192.168.10.24  client.example.com
EOF
