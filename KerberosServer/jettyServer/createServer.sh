#!/bin/bash
set -eux
echo "Create Jetty Server"

sudo apt-get update > /dev/null 2>&1
sudo apt-get upgrade -y > /dev/null 2>&1

sudo apt-get install openjdk-8-jre -y > /dev/null 2>&1

wget http://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.4.8.v20171121/jetty-distribution-9.4.8.v20171121.tar.gz > /dev/null 2>&1
tar xzf jetty-distribution-9.4.8.v20171121.tar.gz > /dev/null 2>&1
mv jetty-distribution-9.4.8.v20171121 jetty9
sudo mv jetty9 /opt
sudo addgroup --quiet --system jetty
sudo adduser --quiet --system --ingroup jetty --no-create-home --disabled-password jetty
sudo usermod -c "Jetty 9" -d /opt/jetty9 -g jetty jetty
sudo chown -R jetty:jetty /opt/jetty9
sudo chmod u=rwx,g=rxs,o= /opt/jetty9

#Configure Jetty 9
sudo mkdir /var/log/jetty9
sudo chown -R jetty:jetty /var/log/jetty9

cat /vagrant/KerberosServer/jettyServer/default.conf > /etc/default/jetty9

cat /vagrant/KerberosServer/jettyServer/crontab > /etc/cron.daily/jetty9

#sudo ln -sf /opt/jetty9/bin/jetty.sh /etc/systemd/system/jetty9.service
#Make Jetty 9 Start on Boot
#sudo update-rc.d jetty9 defaults
sudo /opt/jetty9/bin/jetty.sh start
sudo /opt/jetty9/bin/jetty.sh status

#Deploying Applications
#sudo cp /opt/jetty9/demo-base/webapps/async-rest.war /opt/jetty9/webapps/

#Removing Applications
#sudo rm -f /opt/jetty9/webapps/async-rest.war
