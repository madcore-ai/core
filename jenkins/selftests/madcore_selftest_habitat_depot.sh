#!/bin/bash

echo 'sterted testing Habitat'

if pgrep "hab" > /dev/null
then
    echo "Habitat works"
else
    echo "Habitat down"
    systemctl status habitat-depot
    exit 1
fi

echo 'finished testing Habitat'
