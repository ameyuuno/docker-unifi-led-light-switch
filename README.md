# UniFi LED Light Switch

`unifi-led-light-switch` is a simple self-hosted tool for automatic turning on/off LED light of UniFi controller (for
example, UniFi Dream Machine) by schedule.

## Requirements

- docker
- [_optional_] docker-compose

## Usage

Use tag `v2.*.*` for UDM with Unifi OS (images are multiplatform): 

- `ghcr.io/ameyuuno/unifi-led-light-switch`
- `ghcr.io/ameyuuno/unifi-led-light-switch:latest`
- `ghcr.io/ameyuuno/unifi-led-light-switch:v2.0.0`

If your UDM does not have Unifi OS, use tag `v1.*.*` (use specific tag for specific platform):

- `ameyuuno/unifi-led-light-switch:v1.0.0`
- `ameyuuno/unifi-led-light-switch:v1.0.0-amd64`
- `ameyuuno/unifi-led-light-switch:v1.0.0-arm64`

### Using docker

```
docker pull ameyuuno/unifi-led-light-switch
docker run -d --name unifi-led-light-switch \
    --network host \
    -e UNIFI_USERNAME="usernmae" \
    -e UNIFI_PASSWORD="password" \
    -e UNIFI_BASE_URL="https://192.168.0.1:8443" \
    -e UNIFI_LED_SWITCH_ON_CRONTAB="0 8 * * *" \
    -e UNIFI_LED_SWITCH_OFF_CRONTAB="0 22 * * *" \
    -e TIMEZONE="Europe/Moscow" \
    ameyuuno/unifi-led-light-switch
```

### Using docker-compose

1. Copy `docker-compose.yml` file
2. Create `.env` file and define values for parameters
3. Start container

    ```
    docker-compose pull
    docker-compose up -d
    ```

### Parameters

| Environment                  | Default     | Description                                                                     |
|------------------------------|-------------|---------------------------------------------------------------------------------|
| UNIFI_USERNAME               |             | UniFi username to login to UDM                                                  |
| UNIFI_PASSWORD               |             | UniFi password to login to UDM                                                  |
| UNIFI_BASE_URL               |             | Base URL of UniFi controller which has LED light                                |
| UNIFI_LED_SWITCH_ON_CRONTAB  | `0 7 * * *` | cron schedule expression for switch on LED light; default - at 07:00 every day  |
| UNIFI_LED_SWITCH_OFF_CRONTAB | `0 0 * * *` | cron schedule expression for switch off LED light; default - at 00:00 every day |
| TIMEZONE                     | `UTC`       | Time zone ¯\\_(ツ)_/¯; cron schedule depends on time obviously                  |

### Supported platforms

Next platforms are supported:

- `linux/amd64` 
- `linux/arm64` (tested on Raspberry Pi 4)


## About

[GitHub Repository](https://github.com/ameyuuno/docker-unifi-led-light-switch)

[Docker Hub](https://hub.docker.com/r/ameyuuno/unifi-led-light-switch)

### Motivation

I bought UDM last week and put it in my bedroom, because UDM is beautiful (ﾉ´з`)ノ. But at night its LED light disturbs
(T_T) and it's hard for me to sleep. So I decide to create a this tool which automatically turns on/off its LED by
schedule.

### License

MIT

### Author

[Twitter: @ameyuuno](https://twitter.com/ameyuuno)

## Contributing

Pull requests are welcomed. If you find some bug - open issue (^_^).
