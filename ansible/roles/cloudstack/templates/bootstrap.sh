#!/bin/bash
cd /opt/cloudstack
#setup DB
/usr/local/maven/bin/mvn -Pdeveloper -pl developer -Ddeploydb
/usr/local/maven/bin/mvn -Pdeveloper -pl developer -Ddeploydb-simulator

#start mgt server
nohup /usr/local/maven/bin/mvn -pl client jetty:run -Dsimulator &> /tmp/cloudstack.out &
echo "Starting management server on http://localhost:8080/client"

#cfg datacenter
#dirt wait to let the mgt server start
sleep 30
/usr/local/bin/python2.7 ./tools/marvin/marvin/deployDataCenter.py -i setup/dev/basic.cfg

#run awsapi from source
#nohup /usr/local/maven/bin/mvn -Pawsapi -pl :cloud-awsapi jetty:run &> /tmp/awsapi.out &
#echo "Starting AWSAPI interface on port 7080 use the awsapi.py script to test"
