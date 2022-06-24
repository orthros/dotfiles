#!/usr/bin/env bash

# Number of docker containers running
count=$(docker ps -q | wc -l | sed -r 's/^0$//g')

echo "$LABEL$count"
