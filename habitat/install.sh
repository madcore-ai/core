#!/usr/bin/env bash

sudo groupadd hab && useradd -g hab -s /bin/bash -m hab
sudo usermod -aG docker hab
sudo curl -sSf https://static.rust-lang.org/rustup.sh | sh

# HABITAT INSTALL AND ALL PACKAGES
sudo su -c "mkdir -p /var/lib/jenkins/git/habitat" jenkins
sudo su -c "git clone https://github.com/habitat-sh/habitat /var/lib/jenkins/git/habitat" jenkins
sudo "/var/lib/jenkins/git/habitat/components/hab/install.sh"
sudo hab install core/hab-sup
sudo hab install core/redis
sudo hab install core/hab-depot
sudo hab install core/hab-director
sudo hab pkg binlink core/hab-sup hab-sup
sudo hab pkg binlink core/redis redis-cli
sudo hab pkg binlink core/hab-depot hab-depot
sudo hab pkg binlink core/hab-director hab-director
