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

OS = UBUNTU

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise64"
  config.vm.box_url = OS[:url]
  config.vm.hostname = "simstack"
  config.vm.provision :shell, :inline => "echo \"10.0.2.15 simstack\" >> /etc/hosts"
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", 2048]
    vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
  end

  #config.vm.provision :shell, :path => "riak.sh"

  # Chef solo provisioning
  config.vm.provision "chef_solo" do |chef|
     chef.log_level = :debug
     #chef.add_recipe "apache-cloudstack::maven"
     #chef.add_recipe "apache-cloudstack::python27"
     #chef.add_recipe "apache-cloudstack"
     #chef.add_recipe "apache-cloudstack::marvin"
     chef.add_recipe "riak-cs::package"
     chef.add_recipe "riak"
     chef.add_recipe "riak-cs"
     chef.add_recipe "riak-cs::stanchion"
     chef.add_recipe "riak-cs::control"
     chef.add_recipe "chef-riak-cs-create-admin-user"
  end
  
  # Salt provisioning
  #config.vm.synced_folder "salt/roots", "/srv/"
  #config.vm.provision :salt do |salt|
    #salt.minion_config = 'salt/minion'
    #salt.run_highstate = true
    #salt.verbose = true
    #salt.always_install = true
  # Export database credentials
  #  salt.pillar({
  #        "database" => {
  #          "user" => "jdoe",
  #          "password" => "topsecret"
  #        }
  #      })
  #end

  # Puppet provisioning
  #config.vm.provision "puppet" do |puppet|
  #  puppet.manifests_path = "manifests"
  #  puppet.manifest_file = "default.pp"
  #  puppet.options = "--verbose --debug"
  #end

  # Test script to install CloudStack
  # Kept here as legacy info :)
  #config.vm.provision :shell, :path => "bootstrap-centos.sh"
  #config.vm.provision :shell, :path => "bootstrap-ubuntu.sh"

  # Ansible test
  #config.vm.provision "ansible" do |ansible|
  #  ansible.playbook = "ansible/site.yml"
  #  ansible.verbose = "vvvv"
  #  ansible.host_key_checking = "false"
  #  ansible.sudo_user = "root"
  #end

  # Forward ports for CloudStack and Riak(CS)
  config.vm.network :forwarded_port, host: 8080, guest: 8080
  config.vm.network :forwarded_port, host: 8081, guest: 8081
  #config.vm.network :forwarded_port, host: 7080, guest: 7080
  config.vm.network :forwarded_port, host: 8000, guest: 8000
  config.vm.network :forwarded_port, host: 8001, guest: 80

  #config.vm.network :private_network, :auto_config => true, :ip => "192.168.56.15"

end
