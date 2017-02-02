#!/bin/bash -v
# Ubuntu Xenial Initialization from Cloud-Init or Vagrant
# From Ubuntu user
# Maintained by Madcore Ltd (humans@madcore.ai)


echo "INSTALLING CORE OF MADCORE"

#Generate ssh certifiates
sudo su -c "ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -P '' -C Madcore-Core" jenkins

# PREREQUESITES
pushd /tmp
    sudo wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt-get update
    sudo apt-get install openjdk-8-jdk git jenkins python-pip awscli haproxy letsencrypt libcurl4-gnutls-dev librtmp-dev apache2-utils -y
    sudo pip install --upgrade pip
    sudo pip install -r /opt/madcore/requirements.txt
    sudo groupadd hab && useradd -g hab -s /bin/bash -m hab
    sudo curl -fsSL https://get.docker.com/ | sh
    sudo usermod -aG docker jenkins
    sudo usermod -aG docker hab
    sudo wget https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` -O /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo curl -sSf https://static.rust-lang.org/rustup.sh | sh
popd

# HABITAT
sudo su -c "mkdir -p /var/lib/jenkins/git/habitat" jenkins
sudo su -c "git clone https://github.com/habitat-sh/habitat /var/lib/jenkins/git/habitat" jenkins
sudo "/var/lib/jenkins/git/habitat/components/hab/install.sh"
#sudo "/var/lib/jenkins/git/habitat/terraform/scripts/bootstrap.sh"
sudo hab install core/hab-sup
sudo hab install core/redis
sudo hab install core/hab-depot
sudo hab install core/hab-director
sudo hab pkg binlink core/hab-sup hab-sup
sudo hab pkg binlink core/redis redis-cli
sudo hab pkg binlink core/hab-depot bldr-depot
sudo hab pkg binlink core/hab-director hab-director

# SETUP HABITAT DEPOT + REDIS (REUIQRED FOR JENKINS RESTORE)
sudo bash "/opt/madcore/registryhabitat/setup.sh"

# JENKINS PLUGINS
sudo service jenkins stop
sudo chown -R jenkins:jenkins /opt/madcore
sudo su -c "cp -f /opt/madcore/jenkins/config.xml /var/lib/jenkins/config.xml"
sudo su -c "cp -f /opt/madcore/jenkins/jenkins /etc/init.d/jenkins"
sudo sed -i '/^JAVA_ARGS=/c\JAVA_ARGS=\"-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false\"' /etc/default/jenkins
sudo su -c "sed -i '/<useSecurity>/c\<useSecurity>false</useSecurity>' /var/lib/jenkins/config.xml" jenkins
sudo systemctl daemon-reload
sudo service jenkins start
sudo su -c "until curl -sL -w '%{http_code}' 'http://127.0.0.1:8880/cli/' -o /dev/null | grep -m 1 '200'; do : ; done" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 install-plugin git -deploy" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 install-plugin ssh-credentials" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 install-plugin job-dsl -deploy" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 install-plugin influxdb -deploy" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 install-plugin ws-cleanup -deploy" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 install-plugin workflow-aggregator  -deploy" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 install-plugin parameterized-trigger  -deploy" jenkins

# CONFIGURE AND RUN 1ST SEED JOB (WILL CREATE ALL OTHER JOBS FROM REPO)
SEED_DSL_MASTER_JOB_NAME="madcore.jenkins.dsl.seed.master"
sudo su -c "mkdir -p /var/lib/jenkins/jobs/${SEED_DSL_MASTER_JOB_NAME}" jenkins
sudo su -c "mkdir -p /var/lib/jenkins/workspace/${SEED_DSL_MASTER_JOB_NAME}" jenkins
sudo su -c "ln -s /opt/madcore /var/lib/jenkins/workspace/${SEED_DSL_MASTER_JOB_NAME}/madcore" jenkins

# CREATE JENKINS SCHEDULE FOLDER
sudo mkdir -p /opt/jenkins
sudo chown -R jenkins:jenkins /opt/jenkins
sudo su -c "mkdir -p /opt/jenkins/schedules" jenkins

# CREATE A DUMMY JOB SO THAT DSL PLUGIN DOES NOT ENCOUNTER EMPTY WORKSPACE
sudo su -c "cp /opt/madcore/bin/templates/my_dummy_scheduler.groovy /opt/jenkins/schedules/" jenkins
sudo su -c "cp /var/lib/jenkins/workspace/${SEED_DSL_MASTER_JOB_NAME}/madcore/jenkins/seed-dls_config.xml /var/lib/jenkins/jobs/${SEED_DSL_MASTER_JOB_NAME}/config.xml" jenkins
sudo service jenkins restart
sudo su -c "until curl -sL -w '%{http_code}' 'http://127.0.0.1:8880/cli/' -o /dev/null | grep -m 1 '200'; do : ; done" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 build ${SEED_DSL_MASTER_JOB_NAME}" jenkins
sudo mkdir -p /opt/certs
chown -R jenkins /opt/certs
sudo echo "jenkins ALL=(ALL) NOPASSWD: /opt/madcore/bin/haproxy_get_ssl.py" > /etc/sudoers.d/jenkins
sudo echo "jenkins ALL=(ALL) NOPASSWD: /opt/madcore/jenkins/madcore_reinstall.sh" >> /etc/sudoers.d/jenkins
sudo echo "jenkins ALL=(ALL) NOPASSWD: /opt/madcore/spark/setup.sh" >> /etc/sudoers.d/jenkins
sudo echo "jenkins ALL=(ALL) NOPASSWD: /opt/madcore/jenkins/backup/backup.sh" >> /etc/sudoers.d/jenkins
sudo echo "jenkins ALL=(ALL) NOPASSWD: /opt/madcore/jenkins/backup/restore.sh" >> /etc/sudoers.d/jenkins

# PLUGINS SETUP
sudo mkdir -p /opt/plugins
sudo chown -R jenkins /opt/plugins

# Create  BACKUP folder
sudo mkdir -p /opt/backup
sudo chown -R jenkins:jenkins /opt/backup

# SETUP
sudo bash "/opt/madcore/sslselfsigned/setup.sh"
sudo bash "/opt/madcore/haproxy/setup.sh"
sudo bash "/opt/madcore/registrydocker/setup.sh"
sudo bash "/opt/madcore/kubernetes/setup.sh"
sudo bash "/opt/madcore/heapster/setup.sh"
sudo bash "/opt/madcore/helm/setup.sh"

# Run only if we are on VAGRANT env
if [[ "$ENV" == "VAGRANT" ]]; then
    sudo bash "/opt/madcore/spark/setup.sh" # this setup needs 15-20 min to completely finish
fi
