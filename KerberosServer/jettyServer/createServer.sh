#!/bin/bash
set -eux
echo "Create Jetty Server"

sudo apt-get update > /dev/null 2>&1
sudo apt-get upgrade -y > /dev/null 2>&1

sudo apt-get install openjdk-8-jre -y > /dev/null 2>&1

nohup java -jar /vagrant/jetty-rest.jar &