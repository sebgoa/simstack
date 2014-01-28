#!/usr/bin/env bash

yum -y update
yum -y install ntp
yum -y install java-1.6.0-openjdk
yum -y install java-1.6.0-openjdk-devel
yum -y install tomcat6
yum -y install mysql mysql-server
yum -y install git
yum -y install genisoimage

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
#yum install epel-release

#install python 2.7
wget http://python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2
tar xvf Python-2.7.3.tar.bz2
cd Python-2.7.3
./configure --prefix=/usr/local
make
make altinstall

cd /tmp
wget --no-check-certificate http://pypi.python.org/packages/source/d/distribute/distribute-0.6.49.tar.gz
tar xvf distribute-0.6.49.tar.gz
cd distribute-0.6.49
/usr/local/bin/python2.7 ./setup.py install
/usr/local/bin/easy_install-2.7 virtualenv

#install python setup tools to install marvin
yum -y install python-setuptools
#yum -y install python-pip
yum -y install python-devel

#turn off iptables for testing
service iptables stop

cd /opt
git clone -b 4.3 https://git-wip-us.apache.org/repos/asf/cloudstack.git
cd cloudstack

#build from source 
mvn -Pdeveloper,awsapi -Dsimulator -DskipTests clean install

#setup DB
service mysqld restart
mvn -Pdeveloper -pl developer -Ddeploydb
mvn -Pdeveloper -pl developer -Ddeploydb-simulator

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

