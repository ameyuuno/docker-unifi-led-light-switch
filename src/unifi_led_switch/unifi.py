import dataclasses as dc
import enum
import typing as t

import requests as r
from yarl import URL

Username = t.NewType("Username", str)
Password = t.NewType("Password", str)

DeviceId = t.NewType("DeviceId", str)


@dc.dataclass(frozen=True)
class Credentials:
    username: Username
    password: Password


class ApiClientError(Exception):
    pass


class ApiClient:
    @enum.unique
    class _HttpMethods(enum.Enum):
        GET = "get"
        POST = "post"

    @enum.unique
    class LedLightState(enum.Enum):
        ON = "on"
        OFF = "off"

    def __init__(self, base_url: URL, credentials: Credentials) -> None:
        self.__base_url = base_url
        self.__credentials = credentials

        self.__cookies: t.Optional[t.Mapping[str, str]] = None
        self.__headers: t.Optional[t.Mapping[str, str]] = None

    def sign_in(self) -> None:
        response = r.post(self.__base_url / "api" / "auth" / "login",
                          json={"username": self.__credentials.username, "password": self.__credentials.password,
                                "rememberMe": False},
                          verify=False)

        if response.status_code != 200:
            raise ApiClientError(f"Can not sign in {self.__base_url}. Check base URL and credentials.")

        self.__cookies = {"TOKEN": response.cookies["TOKEN"]}
        self.__headers = {"X-CSRF-Token": response.headers["X-CSRF-Token"]}

    def sign_out(self) -> None:
        response = r.post(self.__base_url / "api" / "auth" / "logout", verify=False,
                          headers=self.__headers, cookies=self.__cookies)

        if response.status_code != 200:
            raise ApiClientError(f"Can not sign out {self.__base_url}.")

        self.__cookies = None
        self.__headers = None

    def get_udm_id(self) -> DeviceId:
        response = r.get(self.__base_url / "proxy" / "network" / "api" / "s" / "default" / "stat" / "device",
                         verify=False, headers=self.__headers, cookies=self.__cookies)

        if response.status_code != 200:
            raise ApiClientError(f"Can not get stats about Unifi devices.")

        for device in response.json()["data"]:
            if device["model"] == "UDM":
                return DeviceId(device["_id"])

        raise ApiClientError(f"There is no UDM among Unifi devices.")

    def switch_led(self, state: LedLightState, id_: DeviceId) -> None:
        response = r.put(self.__base_url / "proxy" / "network" / "api" / "s" / "default" / "rest" / "device" / id_,
                         json={"led_override": state.value, "led_override_color_brightness": 100,
                               "led_override_color": "#0000ff"},
                         verify=False, headers=self.__headers, cookies=self.__cookies)

        if response.status_code != 200:
            raise ApiClientError(f"Can not switch LED light state to {state.name}")
