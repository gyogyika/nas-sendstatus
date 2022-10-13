#!/bin/bash

source /volume1/scripts/settings.ini

#sleep 10

$SENDMAIL "NAS started" "$(date)"

bash /volume1/scripts/GetIP.sh

