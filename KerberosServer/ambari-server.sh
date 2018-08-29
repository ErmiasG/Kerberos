#!/bin/bash
set -eux
echo "Install ambari server"

sudo wget -O /etc/apt/sources.list.d/ambari.list http://public-repo-1.hortonworks.com/ambari/ubuntu16/2.x/updates/2.6.2.2/ambari.list
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com B9733A7A07513CAD
sudo apt-get update
sudo apt-get install ambari-server -y
sudo wget http://central.maven.org/maven2/mysql/mysql-connector-java/8.0.11/mysql-connector-java-8.0.11.jar
sudo mv mysql-connector-java-8.0.11.jar /var/lib/ambari-server/resources/mysql-connector-java.jar

#sudo add-apt-repository ppa:webupd8team/java
#sudo apt-get install oracle-java8-unlimited-jce-policy
#ssh-keygen
