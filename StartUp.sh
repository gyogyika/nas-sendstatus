#!/bin/bash

source /root/settings.ini

#sleep 10

$SENDMAIL "Server started" "$(date)"

bash /root/GetIP.sh

