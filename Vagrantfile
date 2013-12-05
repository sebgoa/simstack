# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "simstack"
  #config.vm.box = "ubuntu12.04"
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", 2048]
    vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
  end

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://people.apache.org/~sebgoa/simstack.box"
  #config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"

  #host-only network setup
  #config.vm.network "private_network", ip: "192.168.56.10"

  #Chef Solo Provisioning
  # Chef solo provisioning
  config.vm.provision "chef_solo" do |chef|
     #chef.add_recipe "cloudstack::management"
     chef.add_recipe "riak-cs::package"
     chef.add_recipe "riak"
     chef.add_recipe "riak-cs"
     chef.add_recipe "riak-cs::stanchion"
  end

  # Test script to install CloudStack
  #config.vm.provision :shell, :path => "bootstrap-centos.sh"
  #config.vm.provision :shell, :path => "bootstrap-ubuntu.sh"
  config.vm.network :forwarded_port, host: 8080, guest: 8080

end
