#!/bin/bash

source /volume1/scripts/settings.ini

echo
URL="$GETIP_URL"?name="$NAME"
echo "GetIP:" "$URL"
curl --max-time $CURL_TIMEOUT "$URL"
echo

