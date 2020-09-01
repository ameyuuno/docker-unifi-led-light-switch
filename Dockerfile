ARG BASEIMAGE_TAG

FROM ameyuuno/baseimage:${BASEIMAGE_TAG}

LABEL maintainer="ameyuuno <ameyuuno@gmail.com>"

ARG TARGETPLATFORM

ENV TIMEZONE=UTC

COPY ./scripts/install-supercronic.sh ./install-supercronic.sh

RUN apk add --no-cache --update curl jq && rm -rf /var/cache/apk/* && \
    chmod +x ./install-supercronic.sh && ./install-supercronic.sh ${TARGETPLATFORM} && rm ./install-supercronic.sh
    
COPY ./scripts/init.sh /srv/init.sh
COPY ./scripts/unifi-led-switch.sh /usr/bin/unifi-led-switch

RUN chmod +x /usr/bin/unifi-led-switch /srv/init.sh

CMD ["supercronic", "/srv/unifi-led-switch-crontab-schedule"]
