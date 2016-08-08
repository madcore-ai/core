#!/bin/bash
echo 'hpsr=new hudson.security.HudsonPrivateSecurityRealm(false); hpsr.createAccount('\'"${1}"\'', '\'"${2}"\'')' | java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 groovy =
