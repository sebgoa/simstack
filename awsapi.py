#!/usr/bin/env python

#Yes you need boto
import boto
import boto.ec2

from boto.s3.key import Key
from boto.s3.connection import S3Connection
from boto.s3.connection import OrdinaryCallingFormat

#Get Eutester from https://github.com/eucalyptus/eutester
from eucaops import ec2ops

#Ipython makes it easy to have an interactive shell for Simstack
from IPython.terminal.embed import InteractiveShellEmbed

cf=OrdinaryCallingFormat()

#Grab the keys from the CloudStack UI, Accounts -> Show Users -> Admin
accesskey=""
secretkey=""

ec2conn = ec2ops.EC2ops(endpoint="localhost",aws_access_key_id=accesskey,aws_secret_access_key=secretkey,is_secure=False,port=7080,path="/awsapi",APIVersion="2012-08-15")

# Grab the keys from the RiakCS interface or the vagrant logs
s3apikey=""
s3secretkey=""

s3conn=S3Connection(aws_access_key_id=s3apikey,aws_secret_access_key=s3secretkey,is_secure=False,host='localhost',port=8081,calling_format=cf)

ipshell = InteractiveShellEmbed(banner1="Hello EucaOps Shell !!")
ipshell()
