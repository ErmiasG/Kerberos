#!/bin/bash
set -eux
echo "Kill all VMs"

vagrant halt kdc
vagrant halt server
vagrant halt client

vagrant destroy kdc
vagrant destroy server
vagrant destroy client