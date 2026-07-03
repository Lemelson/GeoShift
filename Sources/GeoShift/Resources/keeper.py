#!/usr/bin/env python3
"""Continuously keep an attached iPhone at a configured simulated location."""

import argparse
import asyncio
import json
import logging
import os
import signal
from contextlib import suppress
from pathlib import Path

from pymobiledevice3.exceptions import DeviceNotFoundError, NoDeviceConnectedError
from pymobiledevice3.lockdown import create_using_usbmux
from pymobiledevice3.remote.userspace_tunnel import UserspaceRsdTunnel
from pymobiledevice3.services.dvt.instruments.dvt_provider import DvtProvider
from pymobiledevice3.services.dvt.instruments.location_simulation import LocationSimulation


CONFIG_PATH = Path.home() / "Library/Application Support/GeoShift/config.json"
SET_TIMEOUT_SECONDS = 5
WAKE_CHECK_SECONDS = 0.25
DEFAULT_CONFIG = {
    "cityID": "belgrade",
    "cityName": "Белград",
    "country": "Сербия",
    "latitude": 44.8125,
    "longitude": 20.4612,
    "retrySeconds": 5,
    "refreshSeconds": 10,
    "requestID": "default",
}

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)
logger = logging.getLogger("location-keeper")


def load_config() -> dict:
    try:
        data = json.loads(CONFIG_PATH.read_text(encoding="utf-8"))
    except (OSError, ValueError, TypeError):
        return DEFAULT_CONFIG.copy()

    config = DEFAULT_CONFIG | data
    config["retrySeconds"] = max(1, min(60, int(config["retrySeconds"])))
    config["refreshSeconds"] = max(2, min(300, int(config["refreshSeconds"])))
    config["latitude"] = float(config["latitude"])
    config["longitude"] = float(config["longitude"])
    return config


def config_version() -> int:
    try:
        return CONFIG_PATH.stat().st_mtime_ns
    except OSError:
        return 0


async def wait_or_stop(stop_event: asyncio.Event, timeout: float) -> None:
    with suppress(asyncio.TimeoutError):
        await asyncio.wait_for(stop_event.wait(), timeout=timeout)


async def wait_until_timeout_or_config_change(
    stop_event: asyncio.Event,
    timeout: float,
    starting_version: int,
) -> bool:
    deadline = asyncio.get_running_loop().time() + timeout

    while not stop_event.is_set():
        if config_version() != starting_version:
            return True

        remaining = deadline - asyncio.get_running_loop().time()
        if remaining <= 0:
            return False

        await wait_or_stop(stop_event, min(WAKE_CHECK_SECONDS, remaining))

    return False


async def enable_wireless_connections_if_usb_is_available() -> None:
    try:
        lockdown = await create_using_usbmux(
            autopair=True,
            connection_type="USB",
        )
    except (DeviceNotFoundError, NoDeviceConnectedError):
        return

    try:
        if not await lockdown.get_enable_wifi_connections():
            await lockdown.set_enable_wifi_connections(True)
            logger.info("Enabled wireless iPhone connections for future cable-free use")
    finally:
        await lockdown.close()


async def keep_location(stop_event: asyncio.Event) -> None:
    while not stop_event.is_set():
        config = load_config()
        version = config_version()

        try:
            logger.info("Connecting to the first available iPhone")
            await enable_wireless_connections_if_usb_is_available()

            async with UserspaceRsdTunnel(autopair=True) as rsd:
                async with DvtProvider(rsd) as dvt, LocationSimulation(dvt) as location:
                    logger.info("Connected to iPhone")
                    refresh_count = 0
                    last_request_id = ""

                    while not stop_event.is_set():
                        config = load_config()
                        version = config_version()

                        try:
                            await asyncio.wait_for(
                                location.set(config["latitude"], config["longitude"]),
                                timeout=SET_TIMEOUT_SECONDS,
                            )
                        except Exception:
                            logger.exception(
                                "Location refresh failed or timed out; forcing a clean process restart"
                            )
                            os._exit(75)

                        refresh_count += 1
                        if config["requestID"] != last_request_id or refresh_count % 20 == 0:
                            logger.info(
                                "Location set: %s, %s (%.4f, %.4f)",
                                config["cityName"],
                                config["country"],
                                config["latitude"],
                                config["longitude"],
                            )
                            last_request_id = config["requestID"]

                        changed = await wait_until_timeout_or_config_change(
                            stop_event,
                            config["refreshSeconds"],
                            version,
                        )
                        if changed:
                            logger.info("Configuration changed; applying immediately")

                    with suppress(Exception):
                        await location.clear()
        except asyncio.CancelledError:
            raise
        except (DeviceNotFoundError, NoDeviceConnectedError):
            retry_seconds = load_config()["retrySeconds"]
            logger.warning("iPhone is not connected; waiting %d seconds", retry_seconds)
            changed = await wait_until_timeout_or_config_change(stop_event, retry_seconds, version)
            if changed:
                logger.info("Wake request received; retrying immediately")
        except Exception:
            retry_seconds = load_config()["retrySeconds"]
            logger.exception("Connection failed; retrying in %d seconds", retry_seconds)
            changed = await wait_until_timeout_or_config_change(stop_event, retry_seconds, version)
            if changed:
                logger.info("Wake request received; restarting immediately")
            os._exit(75)


async def main() -> None:
    stop_event = asyncio.Event()
    loop = asyncio.get_running_loop()

    loop.add_signal_handler(signal.SIGINT, stop_event.set)
    loop.add_signal_handler(signal.SIGTERM, lambda: os._exit(0))

    logger.info("Location Keeper started")
    try:
        await keep_location(stop_event)
    finally:
        logger.info("Location Keeper stopped")

async def clear_location() -> None:
    async with UserspaceRsdTunnel(autopair=True) as rsd:
        async with DvtProvider(rsd) as dvt, LocationSimulation(dvt) as location:
            await location.clear()
            logger.info("Location simulation cleared")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="GeoShift location simulation worker")
    parser.add_argument("--clear", action="store_true", help="Clear the simulated location and exit")
    arguments = parser.parse_args()
    asyncio.run(clear_location() if arguments.clear else main())
