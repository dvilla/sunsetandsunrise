#!/bin/bash

function get_ip(){
    curl -s ifconfig.co
}

function get_place(){
    curl -s "freegeoip.net/json/$(get_ip)"
}

function get_degree(){
    echo "$(get_place)" | python -m json.tool | grep $1 | sed 's/[^0-9\.-]//g'
}

SUN_MOVEMENT=`curl -s "https://api.sunrise-sunset.org/json?lat=$(get_degree latitude)&lng=$(get_degree longitude)&formatted=0"`

SUNSET_UTC_TIME=`echo $SUN_MOVEMENT | python -m json.tool | grep sunset | sed -E "s/(\"sunset\":[[:blank:]]\")(.*)(.$)/\2/g" | sed -E "s/(00):(00)/\1\2/g" | tr -d ' '` 

SUNRISE_UTC_TIME=`echo $SUN_MOVEMENT | python -m json.tool | grep sunrise | sed -E "s/(\"sunrise\":[[:blank:]]\")(.*)(..$)/\2/g" | sed -E "s/(00):(00)/\1\2/g" | tr -d ' '`

SUNSET_LOCAL_TIME=`date -jf "%Y-%m-%dT%H:%M:%S %z" "${SUNSET_UTC_TIME}" +"%Y/%m/%d %H:%M:%S"`

SUNRISE_UTC_TIME=`date -jf "%Y-%m-%dT%H:%M:%S %z" "${SUNRISE_UTC_TIME}" +"%Y/%m/%d %H:%M:%S"`

echo -e "SUNRISE: $SUNRISE_UTC_TIME\nSUNSET: $SUNSET_LOCAL_TIME"