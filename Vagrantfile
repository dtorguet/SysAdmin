# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
 	config.vm.define "elk" do |elk|
    	elk.vm.box = 'ubuntu/xenial64'
    	elk.vm.box_check_update = false
    	elk.vm.synced_folder ".", "/vagrant"
    	elk.vm.network "private_network", ip: "10.0.15.31"
    	elk.vm.network "forwarded_port", guest: 5601, host: 5600 #kivana 
      elk.vm.network "forwarded_port", guest: 9200, host: 9201 #elastic
      elk.vm.network "forwarded_port", guest: 5044, host: 5045 #logstash 
      elk.vm.provider "virtualbox" do |vb|
      		vb.memory = "4500"
      		vb.cpus = 2
    	end
   	 	elk.vm.provision "shell", path: "ELK_configure.sh" 
  	end

  	config.vm.define "ubuntu" do |ubuntu|
    	ubuntu.vm.box = "ubuntu/xenial64"
    	ubuntu.vm.box_check_update = false
    	ubuntu.vm.synced_folder ".", "/vagrant"
    	ubuntu.vm.network "private_network", ip: "10.0.15.30"
    	ubuntu.vm.network "forwarded_port", guest: 80, host: 8000 #wordpress
    	ubuntu.vm.provider "virtualbox" do |vb|
      		vb.memory = "1024"
    	end
    	ubuntu.vm.provision "shell", path: "bootstrap.sh"
  	end
end
  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  #config.vm.network "forwarded_port", guest: 80, host: 8080
  #config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  #config.vm.provider "virtualbox" do |vb|
  #  Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

