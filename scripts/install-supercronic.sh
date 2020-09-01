#!/bin/sh

set -e

platform=$1

download_and_install_supercronic() {
    SUPERCRONIC_URL=$1
    SUPERCRONIC=$2
    SUPERCRONIC_SHA1SUM=$3

    curl -fsSLO "$SUPERCRONIC_URL"
    echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c -
    chmod +x "$SUPERCRONIC"
    mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}"
    ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic
}

case "${platform}" in
    "linux/amd64")
        url=https://github.com/aptible/supercronic/releases/download/v0.1.11/supercronic-linux-amd64
        fileName=supercronic-linux-amd64
        hash=a2e2d47078a8dafc5949491e5ea7267cc721d67c
        ;;
    "linux/arm")
        url=https://github.com/aptible/supercronic/releases/download/v0.1.11/supercronic-linux-arm
        fileName=supercronic-linux-arm
        hash=0fd443072c2e028fbe6e78dc7880a1870f8ccac8
        ;;
    "linux/arm64")
        url=https://github.com/aptible/supercronic/releases/download/v0.1.11/supercronic-linux-arm64
        fileName=supercronic-linux-arm64
        hash=f011a67f4c56acbef7a75222cb1d7c0d1bb29968
        ;;
    *)
        echo "Unknown platform argument value: '${PLATFORM}'"
        exit 1
        ;;
esac

download_and_install_supercronic $url $fileName $hash
