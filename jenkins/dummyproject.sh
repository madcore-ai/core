#!/bin/bash
min=1
range=15
randy=$RANDOM
let "randy %= 50"
echo ".... started looping"
sleep $[ $randy ]s
echo "...... finished process: "$randy"sec"
ping -c 50 google.com