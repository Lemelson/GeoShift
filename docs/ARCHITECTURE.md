# Architecture

GeoShift separates the macOS user interface from the persistent device worker.

```text
SwiftUI app
  ├─ writes atomic config.json + app heartbeat
  ├─ reads atomic status.json
  ├─ manages a per-user LaunchAgent
  └─ runs the iOS 27 pairing assistant
          │
          ▼
LaunchAgent → bundled keeper.py → pymobiledevice3 → trusted physical iPhone
```

## SwiftUI controller

`KeeperController` owns the selected city, timing settings, state presentation,
pairing flow, and LaunchAgent lifecycle. English is the first-run language;
`LocalizationStore` persists an explicit English/Russian selection without
changing the safety request or worker identity.

## Configuration and status

`config.json` contains a unique request ID, selected destination, intervals,
whether simulation is requested, and the app heartbeat timestamp.

`status.json` is a separate pessimistic latch. Before sending a no-reply location
set command, the worker durably records that simulation may be active. Only a
clear command that returns successfully through the developer channel writes
`simulationMayBeActive = false`. The API does not acknowledge a physical GPS fix.

The UI never treats a missing process, stale log, or truncated diagnostics file
as proof that real GPS has returned.

## Connection paths

The worker chooses one exact trusted iPhone and supports:

1. USB/usbmux;
2. trusted legacy Wi-Fi lockdown;
3. iOS 27+ RemotePairing over Bonjour and a saved pairing record.

Multiple ambiguous devices are rejected. A saved target is never silently
replaced while simulation may be active.

## Fail-safe lifecycle

- Normal Start/Restore updates configuration without tearing down a healthy tunnel.
- Closing the window or Command-Q queues Restore GPS.
- If that handoff cannot be proven safe, termination is refused.
- The app writes a heartbeat every 30 seconds.
- A stale heartbeat older than five minutes converts Start into Restore GPS.
- A five-minute watchdog repairs a missing or stale worker.
- If the phone is offline, `clearPending` persists until the trusted phone returns.
- A corrupt or missing configuration triggers a conservative clear attempt.
- Forced worker termination exits successfully only after a durable clear status.

## Diagnostics

The worker uses rotating 2 MiB logs with two backups. The UI reads only the last
50 events every ten seconds and keeps diagnostics collapsed by default.
