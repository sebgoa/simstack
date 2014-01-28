#!/usr/bin/env bash

apt-get -y update
#apt-get -y install openntpd
apt-get -y install openjdk-6-jdk
#apt-get -y install java-1.6.0-openjdk-devel
#apt-get -y install tomcat6

echo 'mysql-server mysql-server/root_password password foobar' |  debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password foobar' |  debconf-set-selections

apt-get -qqy install mysql-server
service mysql restart

#BAD: Sets the root password to null
mysql -u root -pfoobar < /vagrant/init.sql

apt-get -y install git
apt-get -y install maven

#install python setup tools to install marvin
apt-get -y install python-setuptools
apt-get -y install python-pip

#install mkisofs to create systemvm
apt-get -y install genisoimage

#install riak
#curl http://apt.basho.com/gpg/basho.apt.key | sudo apt-key add -
#bash -c "echo deb http://apt.basho.com $(lsb_release -sc) main > /etc/apt/sources.list.d/basho.list"
#apt-get update
#apt-get -y install riak riak-cs stanchion

#turn off iptables for testing
ufw disable

#clone cloudstack repo
cd /opt
git clone -b 4.3 https://git-wip-us.apache.org/repos/asf/cloudstack.git
cd cloudstack

#build from source 
mvn -Pdeveloper,awsapi -Dsimulator -DskipTests clean install

#setup DB
service mysql restart
mvn -Pdeveloper -pl developer -Ddeploydb
mvn -Pdeveloper -pl developer -Ddeploydb-simulator

#Install Marvin
pip install ./tools/marvin/dist/Marvin-0.1.0.tar.gz 

#stop tomcat to run jetty
#service tomcat6 stop

#start mgt server
nohup mvn -pl client jetty:run -Dsimulator &> /tmp/cloudstack.out &
echo "Starting management server on http://localhost:8080/client"

#cfg datacenter
#dirt wait to let the mgt server start
sleep 30
python ./tools/marvin/marvin/deployDataCenter.py -i setup/dev/basic.cfg

#run awsapi from source
nohup mvn -Pawsapi -pl :cloud-awsapi jetty:run &> /tmp/awsapi.out &
echo "Starting AWSAPI interface on port 7080 use the awsapi.py script to test"
