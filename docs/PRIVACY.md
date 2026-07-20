# Privacy

GeoShift has no analytics, advertising SDK, account system, cloud backend, or
remote application server. It does not upload the selected city, coordinates,
device identity, diagnostics, or pairing material.

## Local data

GeoShift stores runtime data only for the current macOS user:

| Path | Purpose |
| --- | --- |
| `~/Library/Application Support/GeoShift/config.json` | selected city, intervals, request ID, safety heartbeat |
| `~/Library/Application Support/GeoShift/status.json` | worker phase, exact target UDID, clear-safety latch |
| `~/Library/Application Support/GeoShift/pairing-status.json` | temporary pairing assistant state and code |
| `~/Library/Logs/GeoShift.log` | rotating diagnostics |
| `~/.pymobiledevice3/remote_*.plist` | RemotePairing credentials managed by pymobiledevice3 |
| `~/Library/LaunchAgents/com.lemelson.geoshift.keeper.plist` | per-user background worker definition |

The exact device UDID is stored locally while needed to prevent GeoShift from
clearing or controlling the wrong iPhone.

## Network behavior

GeoShift communicates with the trusted iPhone over USB or the local network.
Installing source dependencies and cloning the repository use their normal
internet endpoints; GeoShift itself does not operate a cloud service.

## Publishing diagnostics

Logs can contain device identifiers, local IP addresses, usernames, or local
paths. Review and redact them before opening a public issue. Never publish
pairing records or trust material.

See [Uninstall](UNINSTALL.md) to remove all local data.
