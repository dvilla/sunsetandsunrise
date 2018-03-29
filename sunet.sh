#!/bin/bash

IP=`curl -s ifconfig.co`

PLACE=`curl -s "freegeoip.net/json/${IP}"`

LATITUD=`echo $PLACE | python -m json.tool | grep latitude | sed 's/[^0-9\.-]//g'`

LONGITUD=`echo $PLACE | python -m json.tool | grep longitude | sed 's/[^0-9\.-]//g'`

SUNSET_DATA=`curl -s "https://api.sunrise-sunset.org/json?lat=${LATITUD}&lng=${LONGITUD}&formatted=0"` 

SUNSET_UTC_TIME=`echo $SUNSET_DATA | python -m json.tool | grep sunset | sed -E "s/(\"sunset\":[[:blank:]]\")(.*)(.$)/\2/g" | sed -E "s/(00):(00)/\1\2/g" | tr -d ' '` 

SUNRISE_UTC_TIME=`echo $SUNSET_DATA | python -m json.tool | grep sunrise | sed -E "s/(\"sunrise\":[[:blank:]]\")(.*)(..$)/\2/g" | sed -E "s/(00):(00)/\1\2/g" | tr -d ' '`

SUNSET_LOCAL_TIME=`date -jf "%Y-%m-%dT%H:%M:%S %z" "${SUNSET_UTC_TIME}" +"%Y/%m/%d %H:%M:%S"`

SUNRISE_UTC_TIME=`date -jf "%Y-%m-%dT%H:%M:%S %z" "${SUNRISE_UTC_TIME}" +"%Y/%m/%d %H:%M:%S"`

echo -e "SUNRISE: $SUNRISE_UTC_TIME\nSUNSET: $SUNSET_LOCAL_TIME"