#!/usr/bin/env python3
"""Create a device-initiated iOS 27+ RemotePairing record for GeoShift."""

import asyncio
import json
import os
import time
import uuid
from pathlib import Path

from pymobiledevice3.remote.tunnel_service import PairableHostInfo, serve_pairable_host


STATUS_PATH = Path.home() / "Library/Application Support/GeoShift/pairing-status.json"


def write_status(phase: str, message: str, code: str | None = None, device_udid: str | None = None) -> None:
    payload = {
        "phase": phase,
        "code": code,
        "deviceUDID": device_udid,
        "message": message,
        "updatedAt": time.time(),
    }
    STATUS_PATH.parent.mkdir(parents=True, exist_ok=True)
    temporary = STATUS_PATH.with_name(f".{STATUS_PATH.name}.{os.getpid()}.tmp")
    with temporary.open("w", encoding="utf-8") as output:
        json.dump(payload, output, ensure_ascii=False, sort_keys=True)
        output.flush()
        os.fsync(output.fileno())
    os.replace(temporary, STATUS_PATH)


async def main() -> None:
    host_info = PairableHostInfo(
        name="GeoShift",
        identifier=str(uuid.uuid4()).upper(),
    )
    write_status(
        "advertising",
        "On iPhone, open Settings → Developer → Paired Macs → GeoShift",
    )

    def show_pin(pin: str) -> None:
        write_status("codeReady", "Enter this code on iPhone", code=pin)

    try:
        result = await serve_pairable_host(
            host_info,
            pin_callback=show_pin,
            timeout=180,
        )
    except asyncio.TimeoutError:
        write_status("failed", "The iPhone did not start pairing within three minutes. Open Paired Macs and retry.")
        raise SystemExit(1) from None
    except Exception as error:
        write_status("failed", f"Could not create the Wi-Fi pair: {error}")
        raise

    write_status(
        "paired",
        "Wi-Fi pairing completed. GeoShift is reconnecting…",
        device_udid=result.peer_device.udid,
    )


if __name__ == "__main__":
    asyncio.run(main())
