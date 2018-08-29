#!/bin/bash
set -eux
echo "Install hdp server"
sudo apt update
sudo apt install chrony -y
sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled

source /vagrant/common.env
RESOURCE="/vagrant/KerberosClient/Resource"

cat ${RESOURCE}/krb5.conf > /etc/krb5.conf

sed -i -e 's/${KERBEROS_FQDN}/'$KERBEROS_FQDN'/g' /etc/krb5.conf
sed -i -e 's/${DNS_ZONE}/'$DNS_ZONE'/g' /etc/krb5.conf
sed -i -e 's/${REALM}/'$REALM'/g' /etc/krb5.conf

sudo apt-get update  > /dev/null 2>&1
sudo apt-get -qqy install krb5-user libpam-krb5 libpam-ccreds auth-client-config

#kinit HTTP/hdp.example.com@EXAMPLE.COM -kt /vagrant/http_srv.keytab
