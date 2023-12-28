#!/bin/bash

CURRENT_DIR=$(pwd)

read -p "Enter Caprover backup.tar directory [default: $CURRENT_DIR]: " INPUT_DIR

BACKUP_PATH="${INPUT_DIR:-$CURRENT_DIR}"

docker run -p 80:80 -p 443:443 -p 3000:3000 -e ACCEPTED_TERMS=true -v /var/run/docker.sock:/var/run/docker.sock -v $BACKUP_PATH:/captain caprover/caprover
