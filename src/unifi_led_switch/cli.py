import os
import warnings

import click
from yarl import URL

from unifi_led_switch.unifi import ApiClient, Username, Password, Credentials, ApiClientError

LED_STATES = {
    "on": ApiClient.LedLightState.ON,
    "off": ApiClient.LedLightState.OFF,
}


@click.command()
@click.argument("state", required=True)
def switch(state: str) -> None:
    warnings.filterwarnings("ignore")

    if state not in LED_STATES:
        raise click.UsageError(f"Unknown LED state '{state}'. It can be only 'on' or 'off'.")

    desired_state = LED_STATES[state]

    def get_env_strict(name: str) -> str:
        value = os.getenv(name)
        if value is None:
            raise click.ClickException(f"Environment variable '{name}' is not set.")
        return value

    username = Username(get_env_strict("UNIFI_USERNAME"))
    password = Password(get_env_strict("UNIFI_PASSWORD"))
    baseurl = URL(get_env_strict("UNIFI_BASE_URL"))

    client = ApiClient(baseurl, Credentials(username, password))

    try:
        client.sign_in()
        udm_id = client.get_udm_id()
        client.switch_led(desired_state, udm_id)
        client.sign_out()

    except ApiClientError as err:
        raise click.ClickException(f"Can not switch LED state because of error '{err}'.") from err
