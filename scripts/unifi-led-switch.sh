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
        echo "Unknown state argument value: '${led_state}'"
        exit 1
        ;;
esac

username=${UNIFI_USERNAME}
password=${UNIFI_PASSWORD}
baseUrl=${UNIFI_BASE_URL}
cookie=/tmp/unifi-cookie

make_request() {
    payload=$1
    url=$2

    curl --tlsv1 --silent --cookie ${cookie} --cookie-jar ${cookie} --insecure --data "${payload}" "${url}"
}

print_status() {
    cat | jq '.meta | if .rc == "ok" then .rc else .rc + "(" + .msg + ")" end | "status: " + .'
}

echo "Login on UniFi." 
make_request "{\"username\": \"${username}\", \"password\": \"${password}\"}" "${baseUrl}/api/login" | print_status

echo "Change state of LED to ${led_state}."
make_request "{\"led_enabled\": \"${state}\"}" "${baseUrl}/api/s/default/set/setting/mgmt/" | print_status

echo "Logout." 
make_request "" "${baseUrl}/api/logout" | print_status

rm ${cookie}

echo "Done."
