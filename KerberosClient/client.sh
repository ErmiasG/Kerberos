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

sudo apt-get install default-jdk -y
wget http://apache.mirrors.spacedump.net/hadoop/common/hadoop-2.6.5/hadoop-2.6.5.tar.gz
tar -xzvf hadoop-2.6.5.tar.gz

sudo mv hadoop-2.6.5 /srv/hadoop/
sudo cat ${RESOURCE}/hdfs-site.xml > /srv/hadoop/etc/hadoop/hdfs-site.xml
sudo cat ${RESOURCE}/core-site.xml > /srv/hadoop/etc/hadoop/core-site.xml
