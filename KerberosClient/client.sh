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

kinit george@EXAMPLE.COM <<EOF
georgeldap
EOF

sudo auth-client-config -a -p kerberos_example
klist -e

curl --negotiate -u : -b ~/cookiejar.txt -c ~/cookiejar.txt http://server.example.com:8080/spnego-0.1/api/unprotected/resource | python -m json.tool
curl --negotiate -u : -b ~/cookiejar.txt -c ~/cookiejar.txt http://server.example.com:8080/spnego-0.1/api/protected/resource | python -m json.tool