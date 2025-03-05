#!/bin/bash

source /volume1/scripts/settings.ini

NAS_model=$(awk -F= '/upnpmodelname/ {print $2}' /etc/synoinfo.conf)
NAS_model=$(echo "$NAS_model" | tr -d \")
echo "NAS_model: $NAS_model"
DSM_ver=$(awk -F= '/productversion/ {print $2}' /etc.defaults/VERSION)
DSM_build=$(awk -F= '/buildnumber/ {print $2}' /etc.defaults/VERSION)
DSM_update=$(awk -F= '/smallfixnumber/ {print $2}' /etc.defaults/VERSION)
DSM_version="$DSM_ver $DSM_build Update $DSM_update"
DSM_version=$(echo "$DSM_version" | tr -d \")
echo "DSM_version: $DSM_version"

CPU=$(top -b -n1 | awk '/^%Cpu/{$1="";print $0}')
echo "CPU: $CPU"

CPU_load=$(echo "$CPU" | awk -F, '{print $4}')

# remove decimal point
CPU_load=$(echo "$CPU_load" | awk -F. '{print $1}')

CPU_load=$((100-CPU_load))
echo "CPU_load: $CPU_load"

CPU_temp=$(awk '/CPU_Temperature/ {print $5}' /var/run/hwmon/cpu_temperature.json)
CPU_temp=$(echo "$CPU_temp" | tr -d \")
echo "CPU_temp: $CPU_temp"

Storage_load=$(df -h /volume1/ | awk '/volume1/ {print $5}')
echo "Storage_load: $Storage_load"

Memory_load=$(free -t | awk 'NR==2 {print $3/$2*100}')
echo "Memory_load: $Memory_load"

PING=$(ping -c1 www.msftncsi.com | awk -F/ '{print $5}')
echo PING: $PING

if [ -z "$HDDTEMPATTR" ]
then
  HDDTEMPATTR="194"
fi
echo "HDD temperature SMART attribute: $HDDTEMPATTR"

if [ -z "$SSDWEARLCATTR" ]
then
  SSDWEARLCATTR="177"
fi
echo "SSD Wear_Leveling_Count SMART attribute: $SSDWEARLCATTR"

if [ -n "$HDD1" ]
then
  HDD1_temp=$(smartctl -A --device=sat "$HDD1" | awk "/^$HDDTEMPATTR/"'{print $10}')
  echo "HDD1_temp: $HDD1_temp"
  HDD1_Gsense=$(smartctl -A --device=sat "$HDD1" | awk '/^191/{print $10}')
  echo "HDD1_Gsense: $HDD1_Gsense"
fi

if [ -n "$HDD2" ]
then
  HDD2_temp=$(smartctl -A --device=sat "$HDD2" | awk "/^$HDDTEMPATTR/"'{print $10}')
  echo "HDD2_temp: $HDD2_temp"
  HDD2_Gsense=$(smartctl -A --device=sat "$HDD2" | awk '/^191/{print $10}')
  echo "HDD2_Gsense: $HDD2_Gsense"
fi

if [ -n "$SSD1" ]
then
  SSD1_temp=$(smartctl -A --device=sat "$SSD1" | awk "/^$HDDTEMPATTR/"'{print $10}')
  echo "SSD1_temp: $SSD1_temp"
  SSD1_wear_lc=$(smartctl -A --device=sat "$SSD1" | awk "/^$SSDWEARLCATTR/"'{print $10}')
  if [ "$SSD1_wear_lc" == 0 ]
    then
      SSD1_wear_lc="zero"
  fi
  echo "SSD1_wear_lc: $SSD1_wear_lc"
fi

if [ -n "$SSD2" ]
then
  SSD2_temp=$(smartctl -A --device=sat "$SSD2" | awk "/^$HDDTEMPATTR/"'{print $10}')
  echo "SSD2_temp: $SSD2_temp"
  SSD2_wear_lc=$(smartctl -A --device=sat "$SSD2" | awk "/^$SSDWEARLCATTR/"'{print $10}')
  if [ "$SSD2_wear_lc" == 0 ]
    then
      SSD2_wear_lc="zero"
  fi
  echo "SSD2_wear_lc: $SSD2_wear_lc"
fi

UPS=$(upsc ups@localhost)

UPS_model=$(echo "$UPS" | awk '/ups.model:/{$1="";print $0}')
echo "UPS_model: $UPS_model"

if [ -z "$UPS_battery_date" ]
then
  UPS_battery_date=$(echo "$UPS" | awk '/battery.mfr.date:/{$1="";print $0}')
fi
echo "UPS_battery_date: $UPS_battery_date"

UPS_battery_charge=$(echo "$UPS" | awk '/battery.charge:/{$1="";print $0}')
echo "UPS_battery_charge: $UPS_battery_charge"

UPS_battery_time=$(echo "$UPS" | awk '/battery.runtime:/{$1="";print $0}')
echo "UPS_battery_time: $UPS_battery_time"

UPS_battery_voltage=$(echo "$UPS" | awk '/battery.voltage:/{$1="";print $0}')
echo "UPS_battery_voltage: $UPS_battery_voltage"

UPS_load=$(echo "$UPS" | awk '/ups.load:/{$1="";print $0}')
echo "UPS_load: $UPS_load"

UPS_voltage=$(echo "$UPS" | awk '/input.voltage:/{$1="";print $0}')
echo "UPS_voltage: $UPS_voltage"

UPS_status=$(echo "$UPS" | awk '/ups.status:/{$1="";print $0}')
echo "UPS_status: $UPS_status"

UPS_date=$(echo "$UPS" | awk '/ups.mfr.date:/{$1="";print $0}')
echo "UPS_date: $UPS_date"

Uptime=$(awk '/^btime/{print $2}' /proc/stat)
echo "Uptime: $Uptime"

TIME=$(date +%s)

SPEEDTEST="invalid"
read -r SPEEDTEST < "/tmp/SPEEDTEST"

NOPINGS="invalid"
read -r NOPINGS < "/tmp/NOPINGS"
echo NOPINGS: "$NOPINGS"

curl --get \
  --data-urlencode "set=nas" \
  --data-urlencode "name=$NAME" \
  --data-urlencode "NAS_model=$NAS_model" \
  --data-urlencode "DSM_version=$DSM_version" \
  --data-urlencode "CPU=$CPU" \
  --data-urlencode "CPU_load=$CPU_load" \
  --data-urlencode "CPU_temp=$CPU_temp" \
  --data-urlencode "Storage_load=$Storage_load" \
  --data-urlencode "HDD1_temp=$HDD1_temp" \
  --data-urlencode "HDD1_Gsense=$HDD1_Gsense" \
  --data-urlencode "HDD2_temp=$HDD2_temp" \
  --data-urlencode "HDD2_Gsense=$HDD2_Gsense" \
  --data-urlencode "SSD1_temp=$SSD1_temp" \
  --data-urlencode "SSD1_wear_lc=$SSD1_wear_lc" \
  --data-urlencode "SSD2_temp=$SSD2_temp" \
  --data-urlencode "SSD2_wear_lc=$SSD2_wear_lc" \
  --data-urlencode "Memory_load=$Memory_load" \
  --data-urlencode "Uptime=$Uptime" \
  --data-urlencode "time=$TIME" \
  --data-urlencode "PING=$PING" \
  --data-urlencode "UPS_model=$UPS_model" \
  --data-urlencode "UPS_battery_date=$UPS_battery_date" \
  --data-urlencode "UPS_battery_charge=$UPS_battery_charge" \
  --data-urlencode "UPS_battery_time=$UPS_battery_time" \
  --data-urlencode "UPS_battery_voltage=$UPS_battery_voltage" \
  --data-urlencode "UPS_load=$UPS_load" \
  --data-urlencode "UPS_voltage=$UPS_voltage" \
  --data-urlencode "UPS_status=$UPS_status" \
  --data-urlencode "UPS_date=$UPS_date" \
  --data-urlencode "SPEEDTEST=$SPEEDTEST" \
  --data-urlencode "NOPINGS=$NOPINGS" \
"$STATUS_URL"
