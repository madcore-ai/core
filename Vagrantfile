# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
#!/bin/bash -exak

# VARIABLES THAT CAN BE SET PRIOR TO INSTALLATION

BRANCH_CORE=development
BRANCH_PLUGINS=development

#=== DO NOT EDIT BELOW, UNLESS...

export BRANCH_CORE=$BRANCH_CORE
export BRANCH_PLUGINS=$BRANCH_PLUGINS
curl -L https://raw.githubusercontent.com/madcore-ai/core/$(echo $BRANCH_CORE)/core-init-vagrant.sh | bash

SCRIPT


Vagrant.configure(2) do |config|
  config.vm.box = "xenial"
  config.vm.hostname = "madcore"
  config.vm.network "forwarded_port", guest: 443, host: 8443
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 8081, host: 8081
  config.vm.network "forwarded_port", guest: 8880, host: 8880
  config.vm.network "forwarded_port", guest: 9090, host: 9090
  config.vm.network "forwarded_port", guest: 4040, host: 4040

# config.vm.synced_folder "/Users/polfilm/git_df/madcore", "/opt/madcore"

  config.vm.provider "virtualbox" do |vb|
     vb.name = "madcore"
     vb.memory = "4096"
  end

  config.vm.provision "shell", inline: $script

end
