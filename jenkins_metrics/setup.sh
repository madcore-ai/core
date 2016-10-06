#!/bin/bash
pushd /var/lib/jenkins/plugins
    sudo su -c "wget http://updates.jenkins-ci.org/latest/jacoco.hpi" jenkins
    sudo su -c "wget http://updates.jenkins-ci.org/latest/cobertura.hpi" jenkins
    sudo su -c "wget http://updates.jenkins-ci.org/latest/robot.hpi" jenkins
    sudo su -c "wget http://updates.jenkins-ci.org/latest/maven-plugin.hpi" jenkins
    sudo su -c "wget http://updates.jenkins-ci.org/latest/javadoc.hpi" jenkins
popd
sudo service jenkins restart
