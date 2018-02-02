#!/bin/bash
set -eux
echo "Install MIT Kerberos client"

source /vagrant/common.env
RESOURCE="/vagrant/KerberosClient/Resource"

cat ${RESOURCE}/krb5.conf > /etc/krb5.conf 

sed -i -e 's/${KERBEROS_FQDN}/'$KERBEROS_FQDN'/g' /etc/krb5.conf
sed -i -e 's/${DNS_ZONE}/'$DNS_ZONE'/g' /etc/krb5.conf
sed -i -e 's/${REALM}/'$REALM'/g' /etc/krb5.conf

sudo apt-get update  > /dev/null 2>&1
sudo apt-get -qqy install krb5-user libpam-krb5 libpam-ccreds auth-client-config

kinit john@EXAMPLE.COM <<EOF
johnldap
EOF

sudo auth-client-config -a -p kerberos_example

#echo "-k /etc/krb5-service.keytab get -p john@EXAMPLE.COM HTTP/server.example.com@EXAMPLE.COM" | ktutil
kvno HTTP/server.example.com@EXAMPLE.COM
klist -e