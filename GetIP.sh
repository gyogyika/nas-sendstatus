#!/bin/bash

source /root/settings.ini

echo
URL="$GETIP_URL"?name="$NAME"
echo "GetIP:" "$URL"
curl --max-time 5 "$URL"
echo

echo "freemyip:" "$FREEMYIP"
curl --max-time 5 "$FREEMYIP"
echo
