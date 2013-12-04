#!/usr/bin/env bash

yum -y update
yum -y install ntp
yum -y install java-1.6.0-openjdk
yum -y install java-1.6.0-openjdk-devel
yum -y install tomcat6
yum -y install mysql mysql-server
yum -y install git

#grab maven
wget http://mirror.cc.columbia.edu/pub/software/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
tar xzf apache-maven-3.0.5-bin.tar.gz -C /usr/local
cd /usr/local
ln -s apache-maven-3.0.5 maven

#setup maven system wide
touch /etc/profile.d/maven.sh
echo 'export M2_HOME=/usr/local/maven' > /etc/profile.d/maven.sh
echo 'export PATH=${M2_HOME}/bin:${PATH}' >> /etc/profile.d/maven.sh 
source /etc/profile.d/maven.sh

#setup EPEL
cd /tmp
wget http://mirror-fpt-telecom.fpt.net/fedora/epel/6/i386/epel-release-6-8.noarch.rpm
rpm -ivh epel-release-6-8.noarch.rpm
yum -y update

#install python setup tools to install marvin
yum -y install python-setuptools
yum -y install python-pip
yum -y install python-devel

#install mkisofs to create systemvm
yum -y install genisoimage

#turn off iptables for testing
service iptables stop

cd /opt
git clone https://git-wip-us.apache.org/repos/asf/cloudstack.git
cd cloudstack
git checkout 4.2

#build from source 
mvn -Pdeveloper -Dsimulator -DskipTests clean install

#setup DB
service mysqld restart
mvn -Pdeveloper -pl developer -Ddeploydb
mvn -Pdeveloper -pl developer -Ddeploydb-simulator

#start mgt server
mvn -pl client jetty:run

#run awsapi from source
mvn -Pawsapi -pl :cloud-awsapi jetty:run

