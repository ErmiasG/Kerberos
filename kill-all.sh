#!/bin/bash
set -eux
echo "Kill all VMs"

vagrant halt kdc
vagrant halt server
vagrant halt client

vagrant destroy kdc -f
vagrant destroy server -f
vagrant destroy client -f

rm -f nohup.out