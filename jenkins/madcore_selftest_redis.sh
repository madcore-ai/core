#!/bin/bash
echo 'sterted testing redis'
redis=$(redis-cli ping)

if [ "$redis" == "PONG" ]; then
echo 'redis works'
else
echo 'redis down'
fi

echo 'finished testing redis'