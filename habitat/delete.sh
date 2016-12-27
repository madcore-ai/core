#!/usr/bin/env bash

#delete habitat
echo "started deleting habitat...."
pkill -f hab
rm -rf /var/lib/jenkins/git/habitat
rm -rf /hab
echo "habitat deleted"
sleep 10
