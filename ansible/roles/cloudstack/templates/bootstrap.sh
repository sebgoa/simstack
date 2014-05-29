#!/bin/bash

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
