#!/bin/bash
set -eux
echo "Install MIT Kerberos"

debconf-set-selections <<EOF
krb5-admin-server krb5-admin-server/kadmind boolean true
krb5-admin-server krb5-admin-server/newrealm note
EOF

mkdir -p /var/log/kerberos > /dev/null 2>&1
touch /var/log/kerberos/krb5libs.log > /dev/null 2>&1
touch /var/log/kerberos/krb5kdc.log > /dev/null 2>&1
touch /var/log/kerberos/kadmind.log > /dev/null 2>&1

source /vagrant/common.env
RESOURCE="/vagrant/MasterKDCServer/Resource"
ADMIN_PW=ldap-admin
KDC_DB_KEY=kdcdbkey

cat ${RESOURCE}/kerberos/krb5.conf > /etc/krb5.conf 

sed -i -e 's/${KERBEROS_FQDN}/'$KERBEROS_FQDN'/g' /etc/krb5.conf
sed -i -e 's/${DNS_ZONE}/'$DNS_ZONE'/g' /etc/krb5.conf
sed -i -e 's/${REALM}/'$REALM'/g' /etc/krb5.conf

cat /etc/krb5.conf
cp /etc/krb5.conf /vagrant/krb5.conf
mkdir -p /etc/krb5kdc
mkdir -p /var/lib/krb5kdc

cat ${RESOURCE}/kerberos/kdc.conf > /etc/krb5kdc/kdc.conf 
sed -i -e 's/${REALM}/'$REALM'/g' /etc/krb5kdc/kdc.conf
cat /etc/krb5kdc/kdc.conf

cat ${RESOURCE}/kerberos/kadm5.acl > /etc/krb5kdc/kadm5.acl

sudo apt-get -qqy install krb5-kdc krb5-admin-server krb5-kdc-ldap

sudo gzip -d /usr/share/doc/krb5-kdc-ldap/kerberos.schema.gz
sudo cp /usr/share/doc/krb5-kdc-ldap/kerberos.schema /etc/ldap/schema/

mkdir /tmp/krb_ldif_output
slapcat -f ${RESOURCE}/kerberos/schema_convert.conf -F /tmp/krb_ldif_output -n0 -s "cn={12}kerberos,cn=schema,cn=config" > /tmp/cn=kerberos.ldif 
sed -i '/structuralObjectClass: olcSchemaConfig/Q' /tmp/cn\=kerberos.ldif
sudo ldapadd -Q -Y EXTERNAL -H ldapi:/// -f /tmp/cn\=kerberos.ldif

sudo ldapmodify -Q -Y EXTERNAL -H ldapi:/// -v -f ${RESOURCE}/kerberos/krb5principalname.ldif
sudo ldapmodify -Q -Y EXTERNAL -H ldapi:/// -v -f ${RESOURCE}/kerberos/acl.ldif

sudo kdb5_ldap_util -D  cn=admin,dc=example,dc=com -w $ADMIN_PW create -subtrees dc=example,dc=com -r EXAMPLE.COM -s -H ldap:/// -P $KDC_DB_KEY
sudo kdb5_ldap_util -D  cn=admin,dc=example,dc=com -w $ADMIN_PW stashsrvpw -f /etc/krb5kdc/service.keyfile cn=admin,dc=example,dc=com <<EOF
$ADMIN_PW
$ADMIN_PW
EOF

sudo /etc/init.d/krb5-kdc restart
sudo /etc/init.d/krb5-admin-server restart
sudo /etc/init.d/slapd restart
sleep 5

sudo /usr/sbin/kadmin.local -q 'addprinc -randkey HTTP/server.example.com'
sudo /usr/sbin/kadmin.local -q "ktadd -k /tmp/http_srv.keytab  HTTP/server.example.com"
sudo /usr/sbin/kadmin.local -q 'addprinc -randkey admin/admin'
sudo /usr/sbin/kadmin.local -q "ktadd -k /tmp/admin.keytab admin/admin"

cp /tmp/http_srv.keytab /vagrant/

sudo kadmin.local -q "addprinc -x dn="uid=john,ou=People,dc=example,dc=com" john" <<EOF 
johnldap
johnldap
EOF
sudo kadmin.local -q "addprinc -x dn="uid=george,ou=People,dc=example,dc=com" george" <<EOF 
georgeldap
georgeldap
EOF
sudo kadmin.local -q "addprinc -x dn="uid=tkelly,ou=People,dc=example,dc=com" tkelly" <<EOF 
tkellyldap
tkellyldap
EOF
sudo kadmin.local -q "addprinc -x dn="uid=tlabonte,ou=People,dc=example,dc=com" tlabonte" <<EOF 
tlabonteldap
tlabonteldap
EOF

sudo kinit -V -kt /tmp/admin.keytab admin/admin@EXAMPLE.COM

echo "export KRB5_CONFIG=/etc/krb5kdc/kdc.conf"
