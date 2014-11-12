Simstack
========

A CloudStack and company vagrant box for cloud experimentation.

Simstack is a vagrant box that installs Apache CloudStack and Riak-CS in a single node. This gives an EC2 and an S3 compatible interface in a single box.

CloudStack makes use of a specific feature of his: the simulator. This permits the use of a single box to simulate a virtual data center.
Simstack is aimed at experimentation, development and training for cloud computing engineers/developers.

The aim is to provide recipes for all configuration management systems (i.e Chef, Puppet, Salt, Ansible...) and provide two basic OS flavors: CentOS and Ubuntu.

The base box being used `simstack.box` and `simstack-ubuntu.box` are stock CentOS 6.5 and Ubuntu 13.04 boxes built with Veewee.
Salt was added to the box using the salt bootstrap scripts.

Recipes
=======

Currently only Chef recipes ans Ansible playbooks are available for source install.
Skeleton are present in the Vagrantfile for Puppet and Salt installation, pr welcome.

In CentOS 6.5, the recipes install maven and python 2.7 from source. This complicates the recipes a bit.

Caveat: Those are my first Chef recipes and they make extensive use of `bash`, help me make it better :)

The Riak-CS installation process was taken from the basho github [repo](https://github.com/basho/riak-cs-chef-cookbook) and slightly modified to fit the deployment characteristics of Simstack.

Usage
=====

Simply clone simstack and launch vagrant

    git clone https://github.com/runseb/simstack.git
    cd simstack
    vagrant up

The first time you start the box, simstack will fetch the base veewee box and once booted will among other things clone the entire Apache CloudStack repo. During the build process, maven will also downloads the dependencies. This can take some time, so `vagrant up` then go for a coffee. Once done you can reload the box with:

    vagrant reload --provision

CloudStack UI should be running at `http://localhost:8080/client` , the AWS API should be running on port `7080`, Riak-CS should be running on `8081` with Riak-CS control running on port `8000`, try it by opening `http://localhost:8000`, you should see a single admin user created, get the keys.

In the CloudStack UI, go to users and get the API keys for the admin user.

Use the `awsapi.py` script in the root tree to get an interactive shell on simstack. You will need to install boto, eutester and ipython

License
=======

Simstack is licensed under the Apache v2.0 license

Acknowledgements
================

"Apache", "CloudStack", "Apache CloudStack", the Apache CloudStack logo, the Apache CloudStack Cloud Monkey logo and the Apache feather logos are registered trademarks or trademarks of The Apache Software Foundation.
