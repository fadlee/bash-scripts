#!/bin/bash

CURRENT_DIR=$(pwd)
docker run -p 80:80 -p 443:443 -p 3000:3000 -e ACCEPTED_TERMS=true -v /var/run/docker.sock:/var/run/docker.sock -v $CURRENT_DIR:/captain caprover/caprover
