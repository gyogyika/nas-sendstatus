#!/bin/bash

source /root/settings.ini

#sleep 10

$SENDMAIL "NAS started" "$(date)"

bash /root/GetIP.sh

