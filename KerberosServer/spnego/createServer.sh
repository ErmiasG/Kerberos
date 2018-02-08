#!/bin/bash
set -eux
echo "Create Payara Server"

source /vagrant/common.env

sudo apt-get update > /dev/null 2>&1
sudo apt-get upgrade -y > /dev/null 2>&1

sudo apt-get install openjdk-8-jdk -y > /dev/null 2>&1

tar xzf /vagrant/payara-4.1.2.174.tar.gz > /dev/null 2>&1

cat /vagrant/KerberosServer/spnego/login.conf >> payara41/glassfish/domains/domain1/config/login.conf
sed -i -e 's/${REALM}/'$REALM'/g' payara41/glassfish/domains/domain1/config/login.conf
sed -i -e 's/${SERVER}/'$SERVER'/g' payara41/glassfish/domains/domain1/config/login.conf

cp /vagrant/KerberosServer/spnego/krb5.ini payara41/glassfish/domains/domain1/config/krb5.conf
cp /vagrant/http_srv.keytab payara41/glassfish/domains/domain1/config/http_srv.keytab

sed -i -e 's/${KERBEROS_FQDN}/'$KERBEROS_FQDN'/g' payara41/glassfish/domains/domain1/config/krb5.conf
sed -i -e 's/${DNS_ZONE}/'$DNS_ZONE'/g' payara41/glassfish/domains/domain1/config/krb5.conf
sed -i -e 's/${REALM}/'$REALM'/g' payara41/glassfish/domains/domain1/config/krb5.conf
sed -i -e 's/${SERVER}/'$SERVER'/g' payara41/glassfish/domains/domain1/config/krb5.conf

cat >> payara41/glassfish/domains/domain1/config/tmpfile <<EOF
AS_ADMIN_PASSWORD=
AS_ADMIN_NEWPASSWORD=adminpw
EOF

cat >> payara41/glassfish/domains/domain1/config/pwdfile <<EOF
AS_ADMIN_PASSWORD=adminpw
EOF

payara41/glassfish/bin/asadmin start-domain domain1

payara41/glassfish/bin/asadmin --user admin --passwordfile=payara41/glassfish/domains/domain1/config/tmpfile change-admin-password
payara41/glassfish/bin/asadmin --user admin --passwordfile=payara41/glassfish/domains/domain1/config/pwdfile enable-secure-admin

payara41/glassfish/bin/asadmin --user admin --passwordfile=payara41/glassfish/domains/domain1/config/pwdfile stop-domain domain1
payara41/glassfish/bin/asadmin --user admin --passwordfile=payara41/glassfish/domains/domain1/config/pwdfile start-domain domain1

payara41/glassfish/bin/asadmin --user admin --passwordfile=payara41/glassfish/domains/domain1/config/pwdfile create-jndi-resource \
 --restype javax.naming.ldap.LdapContext \
 --factoryclass com.sun.jndi.ldap.LdapCtxFactory \
 --jndilookupname dc\=example\,dc\=com \
 --property java.naming.provider.url=ldap\\://kdc\.example\.com\\:389:java.naming.ldap.attributes.binary=entryUUID:SECURITY_AUTHENTICATION=none:REFERRAL=follow ldap/LdapResource

payara41/glassfish/bin/asadmin --user admin --passwordfile=payara41/glassfish/domains/domain1/config/pwdfile restart-domain domain1

sudo apt install maven -y > /dev/null 2>&1

mvn clean install -f /vagrant/spnego/pom.xml > /dev/null 2>&1

payara41/glassfish/bin/asadmin --user admin --passwordfile=payara41/glassfish/domains/domain1/config/pwdfile deploy /vagrant/spnego/target/spnego-0.1.war