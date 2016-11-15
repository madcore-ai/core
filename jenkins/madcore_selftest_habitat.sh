#!/bin/bash

echo 'sterted testing Habitat'

if pgrep "hab" > /dev/null
then
    echo "Habitat works"
else
    echo "Habitat down"
fi

echo 'finished testing Habitat'
