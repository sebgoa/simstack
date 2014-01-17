#!/usr/bin/env bash

apt-get -y update
apt-get -y install openntpd
apt-get -y install openjdk-6-jdk
#apt-get -y install java-1.6.0-openjdk-devel
apt-get -y install tomcat6
apt-get -y install mysql-server-5.5
apt-get -y install git
apt-get -y install maven

#install python setup tools to install marvin
apt-get -y install python-setuptools
apt-get -y install python-pip

#install mkisofs to create systemvm
apt-get -y install genisoimage

#install riak
curl http://apt.basho.com/gpg/basho.apt.key | sudo apt-key add -
bash -c "echo deb http://apt.basho.com $(lsb_release -sc) main > /etc/apt/sources.list.d/basho.list"
apt-get update
apt-get -y install riak riak-cs stanchion

#turn off iptables for testing
ufw disable

cd /opt
git clone -b 4.3 https://git-wip-us.apache.org/repos/asf/cloudstack.git
cd cloudstack

#build from source 
mvn -Pdeveloper -Dsimulator -DskipTests clean install

#setup DB
service mysql restart
mvn -Pdeveloper -pl developer -Ddeploydb
mvn -Pdeveloper -pl developer -Ddeploydb-simulator

#stop tomcat to run jetty
service tomcat6 stop

#start mgt server
mvn -pl client jetty:run


#run awsapi from source
mvn -Pawsapi -pl :cloud-awsapi jetty:run
