#!/bin/bash

mkdir -p /captain/data

echo  "{\"skipVerifyingDomains\":\"true\"}" >  /captain/data/config-override.json

docker run -e ACCEPTED_TERMS=true -e MAIN_NODE_IP_ADDRESS=127.0.0.1 -p 80:80 -p 443:443 -p 3000:3000 -v /var/run/docker.sock:/var/run/docker.sock -v /captain:/captain caprover/caprover
