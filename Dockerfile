FROM ameyuuno/baseimage:alpine-3.9.6

ARG PLATFORM

COPY ./scripts/install-supercronic.sh ./install-supercronic.sh

RUN apk add --no-cache --update curl jq && rm -rf /var/cache/apk/* && \
    chmod +x ./install-supercronic.sh && ./install-supercronic.sh ${PLATFORM} && rm ./install-supercronic.sh
    
COPY ./scripts/init.sh /srv/init.sh
COPY ./scripts/unifi-led-switch.sh /usr/bin/unifi-led-switch

RUN chmod +x /usr/bin/unifi-led-switch /srv/init.sh && \
    mkdir -p /srv/log/ && chown -R $APP_USER:$APP_USER /srv/log/

CMD ["supercronic", "/srv/unifi-led-switch-crontab-schedule"]
