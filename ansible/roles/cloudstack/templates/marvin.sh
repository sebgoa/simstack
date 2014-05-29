#!/bin/bash

cd /opt/cloudstack
/usr/local/bin/virtualenv-2.7 marvin-dir
source marvin-dir/bin/activate
/usr/local/maven/bin/mvn -Pdeveloper,awsapi -Dsimulator -DskipTests clean install

