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

DNS_ZONE="example.com"
REALM=$(echo "$DNS_ZONE" | tr '[:lower:]' '[:upper:]')
KERBEROS_FQDN="krbldap.example.com"

cat > /etc/krb5.conf <<EOF
[realms]
    ${REALM} = {
        kdc = ${KERBEROS_FQDN}:8888
        kdc = localhost:8888
        kdc = 127.0.0.1:8888
        kdc = ${KERBEROS_FQDN}:88
        kdc = localhost:88
        kdc = 127.0.0.1:88
        #admin_server = ${KERBEROS_FQDN}:8749
        default_domain = ${DNS_ZONE}
    }
[domain_realm]
    .${DNS_ZONE} = ${REALM}
    ${DNS_ZONE} = ${REALM}
[libdefaults]
    default_realm = ${REALM}
    dns_lookup_realm = false
    dns_lookup_kdc = false
    forwardable=true
    dns_canonicalize_hostname = false
    rdns = false
    ignore_acceptor_hostname = true
    allow_weak_crypto = true
#[kdc]
#    profile = /etc/krb5kdc/kdc.conf
#[logging]
#    default = FILE:/var/log/kerberos/krb5libs.log
#    kdc = FILE:/var/log/kerberos/krb5kdc.log
#    admin_server = FILE:/var/log/kerberos/kadmind.log
EOF

sed -i -e 's/${KERBEROS_FQDN}/'$KERBEROS_FQDN'/g' /etc/krb5.conf
sed -i -e 's/${DNS_ZONE}/'$DNS_ZONE'/g' /etc/krb5.conf
sed -i -e 's/${REALM}/'$REALM'/g' /etc/krb5.conf

cat /etc/krb5.conf
cp /etc/krb5.conf /vagrant/krb5.conf
mkdir -p /etc/krb5kdc
mkdir -p /var/lib/krb5kdc

cat > /etc/krb5kdc/kdc.conf <<EOF
[libdefaults]
        debug = true

[logging]
    kdc = FILE:/var/log/krb5kdc.log
[kdcdefaults]
    kdc_ports = 749,88
    kdc_tcp_ports = 88
    default_realm = ${REALM}
[realms]
    ${REALM} = {
        database_name = /var/lib/krb5kdc/principal
        admin_keytab = FILE:/etc/krb5kdc/kadm5.keytab
        acl_file = /etc/krb5kdc/kadm5.acl
        key_stash_file = /etc/krb5kdc/stash

        kdc_ports = 749,88
        max_life = 10h 0m 0s
        max_renewable_life = 7d 0h 0m 0s
        master_key_type = des3-hmac-sha1
        supported_enctypes = des3-hmac-sha1:normal des-cbc-crc:normal des:normal des:v4 des:norealm des:onlyrealm
        #supported_enctypes = aes256-cts:normal arcfour-hmac:normal des3-hmac-sha1:normal des-cbc-crc:normal des:normal des:v4 des:norealm des:onlyrealm des:afs3
        default_principal_flags = +preauth
    }
EOF
sed -i -e 's/${REALM}/'$REALM'/g' /etc/krb5kdc/kdc.conf
cat /etc/krb5kdc/kdc.conf

cat > /etc/krb5kdc/kadm5.acl <<EOF
*/admin@EXAMPLE.COM    *
EOF

sudo apt-get -qqy install krb5-kdc krb5-admin-server

sudo kdb5_util create -s -P aaaBBBccc123
sudo /etc/init.d/krb5-kdc restart
sudo /etc/init.d/krb5-admin-server restart
sudo /etc/init.d/slapd restart

sudo /usr/sbin/kadmin.local -q 'addprinc -randkey HTTP/localhost'
sudo /usr/sbin/kadmin.local -q "ktadd -k /tmp/http_srv.keytab  HTTP/localhost"
sudo /usr/sbin/kadmin.local -q 'addprinc -randkey admin/admin'
sudo /usr/sbin/kadmin.local -q "ktadd -k /tmp/admin.keytab admin/admin"

sudo kinit -V -kt /tmp/admin.keytab admin/admin@EXAMPLE.COM

echo "export KRB5_CONFIG=/etc/krb5kdc/kdc.conf"
