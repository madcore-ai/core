# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "xenial"
  config.vm.hostname = "xenial2"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 8081, host: 8081
  config.vm.network "forwarded_port", guest: 443, host: 8443
# config.vm.synced_folder "/Users/polfilm/git_df/controlbox", "/opt/controlbox"

  config.vm.provider "virtualbox" do |vb|
     vb.name = "xenial2"
     vb.memory = "2048"
  end

  config.vm.provision "shell", path: "https://bitbucket.org/ronaanimation/controlbox/raw/development/cb-init-vagrant.sh"
end
