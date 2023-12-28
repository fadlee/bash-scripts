#!/bin/bash

read -p "Enter Caprover URL, with http(s): " CAPROVER_URL

read -p "Enter Caprover password: " CAPROVER_PASSWORD

if [ $(dpkg-query -W -f='${Status}' jq 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    apt-get update && apt-get install -y jq
fi

API_TOKEN=$(curl $CAPROVER_URL/api/v2/login \
    -H 'x-namespace: captain' \
    -H 'content-type: application/json;charset=UTF-8' \
    --data-raw "{\"password\":\"$CAPROVER_PASSWORD\"}" \
    --compressed --silent | jq -r ".data.token")

DOWNLOAD_TOKEN=$(curl $CAPROVER_URL/api/v2/user/system/createbackup \
    -H "x-captain-auth: $API_TOKEN" \
    -H 'x-namespace: captain' \
    --data-raw '{"postDownloadFileName":"backup.tar"}' \
    --compressed --silent | jq -r ".data.downloadToken")

if [ ${#DOWNLOAD_TOKEN} -le 10 ]; then
    echo "DOWNLOAD_TOKEN must be at least 10 char long"
    exit 1
fi

wget -q "$CAPROVER_URL/api/v2/downloads/?namespace=captain&downloadToken=$DOWNLOAD_TOKEN" -O backup.tar

echo "Caprover backup downloaded as backup.tar"
