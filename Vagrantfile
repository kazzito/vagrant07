# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  $is_windows = RbConfig::CONFIG['host_os'] =~ /mswin|msys|mingw|cygwin|bccwin/i
  $is_osx = RbConfig::CONFIG['host_os'] =~ /darwin/i

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "bento/centos-6.7"
  config.vm.hostname = "januslocal"

  # WEBサーバのポートを指定
  if $is_windows then
    config.vm.network "forwarded_port", guest: 80, host: 80
  else
    config.vm.network "forwarded_port", guest: 80, host: 10080

    config.trigger.after [:provision, :up, :reload] do
      system('echo "rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 80 -> 127.0.0.1 port 10080" | sudo pfctl -ef - > /dev/null 2>&1')
      system('echo "set packet filter 127.0.0.1:80 -> 127.0.0.1:10080"')
    end

    config.trigger.after [:halt, :destroy] do
      system("sudo pfctl -df /etc/pf.conf > /dev/null 2>&1")
      system('echo "reset packet filter"')
    end
  end

  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.provider "virtualbox" do |vb|
    vb.name = "januslocal"
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.omnibus.chef_version = :latest

  if $is_windows then
    config.vm.synced_folder "../appRoot/", "/var/www/html",
      :create => true, 
      :owner => 'vagrant', 
      :group => 'vagrant', 
      :mount_options => ['dmode=777', 'fmode=777']
  else
    #config.vm.synced_folder "../appRoot/", "/var/www/html", type: "nfs"
    config.bindfs.default_options = {
      force_user:   'vagrant',
      force_group:  'vagrant',
      perms:        'u=rwX:g=rwX:o=rwX',
      create_with_perms:'u=rwx:g=rwx:o=rwx'
    }
    config.vm.synced_folder "../appRoot/", "/home/vagrant/sync_nfs", type: "nfs"
    config.bindfs.bind_folder "/home/vagrant/sync_nfs", "/var/www/html", o:"nonempty"
    #config.bindfs.bind_folder "/var/www/html", "/home/vagrant/sync_nfs", :owner => "1111", :group => "1111", :'create-as-user' => true, :perms => "u=rwx:g=rwx:o=rwx", :'create-with-perms' => "u=rwx:g=rwx:o=rwx", :'chown-ignore' => true, :'chgrp-ignore' => true, :'chmod-ignore' => true
  end
  
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

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
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  #TEST

  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]

    chef.add_recipe "common"
    chef.add_recipe "yum-epel"
    chef.add_recipe "yum-remi"
    chef.add_recipe "git"
    chef.add_recipe "apache"
    chef.add_recipe "php"
    chef.add_recipe "mysql"
    chef.add_recipe "finish"

  end

end
