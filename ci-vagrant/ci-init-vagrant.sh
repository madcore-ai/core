#!/bin/bash -xakv +e
# Madcore Core (c) 2015-2017 Madcore Ltd on MIT License
# Madcore is a trademark of Madcore Ltd in United Kingdom
# All other trademarks belong to their respective owners

sudo echo ENV=VAGRANT >> /etc/environment
sudo echo MADCORE_BRANCH=$BRANCH_CORE >> /etc/environment
sudo echo MADCORE_COMMIT=FETCH_HEAD >> /etc/environment
sudo echo MADCORE_PLUGINS_BRANCH=$BRANCH_PLUGINS >> /etc/environment
sudo echo MADCORE_PLUGINS_COMMIT=FETCH_HEAD >> /etc/environment

echo 'Installing Madcore CI - Vagrant Edition...'

sudo apt-get update
sudo apt-get install git -y
pushd /opt
    echo "CLONING BRANCH CORE: $BRANCH_CORE"
    sudo git clone -b $BRANCH_CORE https://github.com/madcore-ai/core.git madcore
    sudo chown -R ubuntu:ubuntu /opt/madcore
popd

# PREREQUESITES
pushd /tmp
    sudo wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt-get update
    sudo apt-get install openjdk-8-jdk jenkins git python-pip awscli libcurl4-gnutls-dev librtmp-dev apache2-utils jq -y
    sudo pip install --upgrade pip
    sudo pip install -r /opt/madcore/requirements.txt
popd

# JENKINS PLUGINS
sudo su -c "source /etc/environment" jenkins
sudo service jenkins stop
sudo chown -R jenkins:jenkins /opt/madcore
sudo su -c "cp -f /opt/madcore/jenkins/config.xml /var/lib/jenkins/config.xml"
sudo su -c "cp -f /opt/madcore/jenkins/jenkins /etc/init.d/jenkins"
sudo sed -i '/^JAVA_ARGS=/c\JAVA_ARGS=\"-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false\"' /etc/default/jenkins
sudo su -c "sed -i '/<useSecurity>/c\<useSecurity>false</useSecurity>' /var/lib/jenkins/config.xml" jenkins

# JENKINS REPLACE SET GLOBAL ENV VARIABLES
sudo su -c "sed -ie 's/\${MADCORE_BRANCH}/${MADCORE_BRANCH}/g' /var/lib/jenkins/config.xml" jenkins
sudo su -c "sed -ie 's/\${MADCORE_COMMIT}/${MADCORE_COMMIT}/g' /var/lib/jenkins/config.xml" jenkins
sudo su -c "sed -ie 's/\${MADCORE_PLUGINS_BRANCH}/${MADCORE_PLUGINS_BRANCH}/g' /var/lib/jenkins/config.xml" jenkins
sudo su -c "sed -ie 's/\${MADCORE_PLUGINS_COMMIT}/${MADCORE_PLUGINS_COMMIT}/g' /var/lib/jenkins/config.xml" jenkins

#sudo systemctl daemon-reload
sudo service jenkins start
sudo su -c "until curl -sL -w '%{http_code}' 'http://127.0.0.1:8880/cli/' -o /dev/null | grep -m 1 '200'; do : ; done" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 install-plugin git -deploy" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 install-plugin ssh-credentials" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 install-plugin job-dsl -deploy" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 install-plugin influxdb -deploy" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 install-plugin ws-cleanup -deploy" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 install-plugin workflow-aggregator  -deploy" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 install-plugin parameterized-trigger  -deploy" jenkins
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 install-plugin blueocean -deploy" jenkins

# CONFIGURE AND RUN 1ST SEED JOB (WILL CREATE ALL OTHER JOBS FROM REPO)
SEED_DSL_MASTER_JOB_NAME="madcore.jenkins.dsl.seed.master"
sudo su -c "mkdir -p /var/lib/jenkins/jobs/${SEED_DSL_MASTER_JOB_NAME}" jenkins
sudo su -c "mkdir -p /var/lib/jenkins/workspace/${SEED_DSL_MASTER_JOB_NAME}" jenkins
sudo su -c "ln -s /opt/madcore /var/lib/jenkins/workspace/${SEED_DSL_MASTER_JOB_NAME}/madcore" jenkins

# CREATE JENKINS SCHEDULE FOLDER
#sudo mkdir -p /opt/jenkins
#sudo chown -R jenkins:jenkins /opt/jenkins
#sudo su -c "mkdir -p /opt/jenkins/schedules" jenkins

# CREATE A DUMMY JOB SO THAT DSL PLUGIN DOES NOT ENCOUNTER EMPTY WORKSPACE
#sudo su -c "cp /opt/madcore/bin/templates/my_dummy_scheduler.groovy /opt/jenkins/schedules/" jenkins
#sudo su -c "cp /var/lib/jenkins/workspace/${SEED_DSL_MASTER_JOB_NAME}/madcore/jenkins/seed-dls_config.xml /var/lib/jenkins/jobs/${SEED_DSL_MASTER_JOB_NAME}/config.xml" jenkins
sudo service jenkins restart
#sudo su -c "until curl -sL -w '%{http_code}' 'http://127.0.0.1:8880/cli/' -o /dev/null | grep -m 1 '200'; do : ; done" jenkins
#sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 build ${SEED_DSL_MASTER_JOB_NAME}" jenkins

