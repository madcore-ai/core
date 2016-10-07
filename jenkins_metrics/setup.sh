#!/bin/bash
pushd /var/lib/jenkins/plugins
    sudo su -c "wget http://updates.jenkins-ci.org/latest/jacoco.hpi" jenkins
    sudo su -c "wget http://updates.jenkins-ci.org/latest/cobertura.hpi" jenkins
    sudo su -c "wget http://updates.jenkins-ci.org/latest/robot.hpi" jenkins
    sudo su -c "wget http://updates.jenkins-ci.org/latest/maven-plugin.hpi" jenkins
    sudo su -c "wget http://updates.jenkins-ci.org/latest/javadoc.hpi" jenkins
    sudo su -c " wget http://updates.jenkins-ci.org/latest/influxdb.hpi" jenkins
popd
sudo service jenkins restart
rm -rf /var/lib/jenkins/jenkinsci.plugins.influxdb.InfluxDbPublisher.xml
cp /opt/controlbox/jenkins_metrics/jenkinsci.plugins.influxdb.InfluxDbPublisher.xml /var/lib/jenkins/jenkinsci.plugins.influxdb.InfluxDbPublisher.xml 
curl -i -GET http://localhost:8086/query --data-urlencode "q=CREATE DATABASE jenkins_logs"
curl -i -GET http://localhost:8086/query --data-urlencode "q=CREATE USER test WITH PASSWORD '12345'"
service jenkins restart

