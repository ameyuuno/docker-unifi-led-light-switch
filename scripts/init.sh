#!/bin/sh

cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
echo "${TIMEZONE}" > /etc/timezone
echo "Set timezone: ${TIMEZONE} [$(date)]"

echo "Generate crontab schedule file."

led_switch_on_schedule=${UNIFI_LED_SWITCH_ON_CRONTAB:-"0 7 * * *"}
led_switch_off_schedule=${UNIFI_LED_SWITCH_OFF_CRONTAB:-"0 0 * * *"}

echo "${led_switch_on_schedule} unifi-led-switch on" >> /srv/unifi-led-switch-crontab-schedule
echo "${led_switch_off_schedule} unifi-led-switch off" >> /srv/unifi-led-switch-crontab-schedule

echo "Schedule:"
echo "---------"
cat /srv/unifi-led-switch-crontab-schedule
echo "---------"

echo "Execute: [$@]"
exec $@
