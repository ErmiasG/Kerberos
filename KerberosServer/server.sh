#!/bin/bash
set -eux
echo "Install MIT Kerberos server"

source /vagrant/common.env
RESOURCE="/vagrant/KerberosClient/Resource"

cat ${RESOURCE}/krb5.conf > /etc/krb5.conf 

sed -i -e 's/${KERBEROS_FQDN}/'$KERBEROS_FQDN'/g' /etc/krb5.conf
sed -i -e 's/${DNS_ZONE}/'$DNS_ZONE'/g' /etc/krb5.conf
sed -i -e 's/${REALM}/'$REALM'/g' /etc/krb5.conf

cat /vagrant/KerberosServer/jettyServer/krb5.ini > /etc/krb5.ini
cat /vagrant/KerberosServer/jettyServer/spnego.conf > /etc/spnego.conf
cat /vagrant/KerberosServer/jettyServer/spnego.properties > /etc/spnego.properties

sed -i -e 's/${KERBEROS_FQDN}/'$KERBEROS_FQDN'/g' /etc/krb5.ini
sed -i -e 's/${DNS_ZONE}/'$DNS_ZONE'/g' /etc/krb5.ini
sed -i -e 's/${REALM}/'$REALM'/g' /etc/krb5.ini
sed -i -e 's/${SERVER}/'$SERVER'/g' /etc/krb5.ini

sed -i -e 's/${KERBEROS_FQDN}/'$KERBEROS_FQDN'/g' /etc/spnego.conf
sed -i -e 's/${DNS_ZONE}/'$DNS_ZONE'/g' /etc/spnego.conf
sed -i -e 's/${REALM}/'$REALM'/g' /etc/spnego.conf
sed -i -e 's/${SERVER}/'$SERVER'/g' /etc/spnego.conf

sed -i -e 's/${KERBEROS_FQDN}/'$KERBEROS_FQDN'/g' /etc/spnego.properties
sed -i -e 's/${DNS_ZONE}/'$DNS_ZONE'/g' /etc/spnego.properties
sed -i -e 's/${REALM}/'$REALM'/g' /etc/spnego.properties
sed -i -e 's/${SERVER}/'$SERVER'/g' /etc/spnego.properties

sudo apt-get update  > /dev/null 2>&1
sudo apt-get -qqy install krb5-user libpam-krb5 libpam-ccreds auth-client-config 

kinit HTTP/server.example.com@EXAMPLE.COM -kt /vagrant/http_srv.keytab