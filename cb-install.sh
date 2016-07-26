#!/bin/bash -v
# Ubuntu Xenial Initialization from Cloud-Init or Vagrant
# From Ubuntu user
# Maintained by Peter Styk (devopsfactory@styk.tv)

# PREREQUESITES
pushd /tmp
    sudo wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt-get update
    sudo apt-get install openjdk-8-jdk git jenkins -y
    sudo groupadd hab && useradd -g hab -s /bin/bash -m hab
    sudo curl -fsSL https://get.docker.com/ | sh
    sudo usermod -aG docker jenkins
    sudo usermod -aG docker hab
    sudo curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    sudo curl -sSf https://static.rust-lang.org/rustup.sh | sh
popd

# HABITAT
sudo su -c "mkdir -p /var/lib/jenkins/git/habitat" jenkins
sudo su -c "git clone https://github.com/habitat-sh/habitat /var/lib/jenkins/git/habitat" jenkins
sudo "/var/lib/jenkins/git/habitat/components/hab/install.sh"
sudo "/var/lib/jenkins/git/habitat/terraform/scripts/bootstrap.sh"


# JENKINS PLUGINS
sudo su -c "sed -i '/JAVA_ARGS=/c\JAVA_ARGS=\"-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false\"' /var/lib/jenkins/config.xml" jenkins
sudo su -c "sed -i '/<useSecurity>/c\<useSecurity>false</useSecurity>' /var/lib/jenkins/config.xml" jenkins
sudo service jenkins restart
sudo su -c "until curl -sL -w '%{http_code}' 'http://127.0.0.1:8080/cli/' -o /dev/null | grep -m 1 '200'; do : ; done" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin git -deploy" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin ssh-credentials" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin job-dsl -deploy" jenkins

# CONFIGURE AND RUN 1ST SEED JOB (WILL CREATE ALL OTHER JOBS FROM REPO)
sudo su -c "mkdir -p /var/lib/jenkins/jobs/seed-dsl" jenkins
sudo chown -R jenkins:jenkins /opt/controlbox
sudo su -c "cp /var/lib/jenkins/workspace/seed-dsl/controlbox/seed-dls_config.xml /var/lib/jenkins/jobs/seed-dsl/config.xml" jenkins
sudo service jenkins restart
sudo su -c "until curl -sL -w '%{http_code}' 'http://127.0.0.1:8080/cli/' -o /dev/null | grep -m 1 '200'; do : ; done" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 build seed-dsl" jenkins
