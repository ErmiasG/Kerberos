#!/bin/bash
set -eux
echo "Create Payara Server"

sudo apt-get update > /dev/null 2>&1
sudo apt-get upgrade -y > /dev/null 2>&1

sudo apt-get install openjdk-8-jdk -y > /dev/null 2>&1

tar xzf /vagrant/payara-4.1.2.174.tar.gz > /dev/null 2>&1

cat /vagrant/KerberosServer/spnego/login.conf >> payara41/glassfish/domains/domain1/config/login.conf
sed -i -e 's/${REALM}/'$REALM'/g' payara41/glassfish/domains/domain1/config/login.conf
sed -i -e 's/${SERVER}/'$SERVER'/g' payara41/glassfish/domains/domain1/config/login.conf

cp /vagrant/KerberosServer/spnego/krb5.ini payara41/glassfish/domains/domain1/config/krb5.conf

sed -i -e 's/${KERBEROS_FQDN}/'$KERBEROS_FQDN'/g' payara41/glassfish/domains/domain1/config/krb5.conf
sed -i -e 's/${DNS_ZONE}/'$DNS_ZONE'/g' payara41/glassfish/domains/domain1/config/krb5.conf
sed -i -e 's/${REALM}/'$REALM'/g' payara41/glassfish/domains/domain1/config/krb5.conf
sed -i -e 's/${SERVER}/'$SERVER'/g' payara41/glassfish/domains/domain1/config/krb5.conf

payara41/glassfish/bin/asadmin start-domain domain1
payara41/glassfish/bin/asadmin deploy /vagrant/hello-spnego.war