FROM ghcr.io/ameyuuno/baseimage/python:3.8.12-alpine3.14 as build

ARG TARGETPLATFORM

ENV PATH="/etc/poetry/bin:${PATH}" \
    POETRY_HOME="/etc/poetry" \
    POETRY_VERSION="1.1.10"

LABEL maintainer="ameyuuno <ameyuuno@gmail.com>"

WORKDIR /build

COPY ./scripts/install-supercronic.sh ./install-supercronic.sh

RUN apk add --no-cache curl gcc libffi-dev musl-dev && rm -rf /var/cache/apk/* && \
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python - && \
    chmod +x ./install-supercronic.sh && ./install-supercronic.sh ${TARGETPLATFORM}

COPY poetry.lock poetry.lock
COPY pyproject.toml pyproject.toml
COPY src src

RUN poetry build && python -m pip install --target /build/target/ dist/*.whl

FROM ghcr.io/ameyuuno/baseimage/python:3.8.12-alpine3.14 as runtime

ENV PATH="/build/target/bin:${PATH}" \
    PYTHONPATH="/build/target:${PYTHONPATH}" \
    TIMEZONE="UTC"

RUN apk add --no-cache tzdata && rm -rf /var/cache/apk/*

COPY --from=build /usr/local/bin/supercronic /usr/local/bin/supercronic
COPY --from=build /build/target/ /build/target/
COPY ./scripts/init.sh /srv/init.sh

RUN chmod +x /srv/init.sh

ENTRYPOINT ["/srv/init.sh"]

CMD ["supercronic", "/srv/unifi-led-switch-crontab-schedule"]
