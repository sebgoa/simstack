# -*- mode: ruby -*-
# vi: set ft=ruby :

CENTOS = {
  box: "simstack",
  url: "http://people.apache.org/~sebgoa/simstack.box"
}
UBUNTU = {
  box: "simstack-ubuntu",
  url: "http://people.apache.org/~sebgoa/simstack-ubuntu.box"
}

OS = CENTOS

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = OS[:box]
  config.vm.box_url = OS[:url]
  config.vm.hostname = "simstack"
  config.vm.provision :shell, :inline => "echo \"10.0.2.15 simstack\" >> /etc/hosts"
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", 2048]
    vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
  end

  #host-only network setup
  #config.vm.network "private_network", ip: "192.168.56.10"

  # Chef solo provisioning
  config.vm.provision "chef_solo" do |chef|
     chef.add_recipe "apache-cloudstack::maven"
     chef.add_recipe "apache-cloudstack::python27"
     #chef.add_recipe "cloudstack"
     #chef.add_recipe "riak-cs::package"
     #chef.add_recipe "riak"
     #chef.add_recipe "riak-cs"
     #chef.add_recipe "riak-cs::stanchion"
     #chef.add_recipe "riak-cs::control"
     #chef.add_recipe "chef-riak-cs-create-admin-user"
  end

  # Test script to install CloudStack
  #config.vm.provision :shell, :path => "bootstrap-centos.sh"
  #config.vm.provision :shell, :path => "bootstrap-ubuntu.sh"
  config.vm.network :forwarded_port, host: 8080, guest: 8080
  config.vm.network :forwarded_port, host: 8081, guest: 8081
  config.vm.network :forwarded_port, host: 7080, guest: 7080
  config.vm.network :forwarded_port, host: 8000, guest: 8000

end
