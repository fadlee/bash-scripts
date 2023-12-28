#!/bin/bash

backup_file="/captain/backup.tar"

if [ -e "$backup_file" ]; then
    docker run -p 80:80 -p 443:443 -p 3000:3000 -e ACCEPTED_TERMS=true -v /var/run/docker.sock:/var/run/docker.sock -v /captain:/captain caprover/caprover
else
    echo "Error: $backup_file not exists"
fi