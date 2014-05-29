## simstack provisioned by ansible

- Requires Ansible 1.4 or newer
- Expects CentOS 6.5 box

These playbooks provision a Vagrant virtual machine with the simstack.

Uncomment this in the Vagrantfile

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/provision.yml"
    ansible.verbose = "v"
    ansible.host_key_checking = "false"
    ansible.sudo_user = "root"
  end


Then provision the VM from the directory with the Vagrantfile.

	vagrant provision

The playbooks will configure MySQL, Maven, Python & Cloudstack. When the run
is complete, you can hit access server to begin exploring simstack.

We would love to see contributions and improvements, so please fork this
repository on GitHub and send us your changes via pull requests.

