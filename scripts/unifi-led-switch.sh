#!/bin/sh

set -e

echo "Run LED light switch script [$(date)]."

led_state=$1

case "${led_state}" in
    on)
        state=true
        ;;
    off)
        state=false
        ;;
    *)
        echo "Unknown state argument value: ${led_state}"
        exit 1
        ;;
esac

username=$2
password=$3
baseUrl=$4
cookie=/tmp/unifi-cookie

curl_cmd="curl --tlsv1 --silent --cookie ${cookie} --cookie-jar ${cookie} --insecure "

echo "Login on UniFi." 
${curl_cmd} --data "{\"username\":\"${username}\", \"password\":\"${password}\"}" ${baseUrl}/api/login | jq '.meta | .rc'

echo "Change state of LED to ${led_state}."
${curl_cmd} --data "{\"led_enabled\":\"${state}\"}" ${baseUrl}/api/s/default/set/setting/mgmt/ | jq '.meta | .rc'

echo "Done."
