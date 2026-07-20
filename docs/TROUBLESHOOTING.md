# Troubleshooting

## GeoShift is waiting for iPhone

1. Unlock the iPhone and keep its screen awake temporarily.
2. Confirm the Mac and iPhone use the same local network.
3. Open **Settings → Connection** in GeoShift and choose **Check connection**.
4. On iOS 27+, verify that GeoShift still appears under iPhone
   **Settings → Developer → Paired Macs**.
5. Disable guest-network isolation or allow local traffic through VPN/firewall
   software.
6. Use a trusted USB connection as a fallback.

GeoShift deliberately keeps a pending Restore GPS request when the phone is
offline. Reconnecting the trusted phone lets the worker finish that clear.

## The phone still shows the previous city

- Choose **Restore GPS** and wait for **Simulation cleared**.
- Keep the iPhone unlocked until GeoShift reports that the clear command was sent.
- Open Apple Maps and wait for a fresh location fix.
- Restarting the iPhone clears the current simulation. If **Start** is still
  requested and the worker remains active, GeoShift may reconnect and reapply it.

The developer API's `clear` operation does not request a reply and cannot read
back the physical GPS coordinate. A successful send is the strongest programmatic
signal; Maps is the practical sensor-side verification.

## Pairing code never appears

- Keep **Paired Macs** open while the assistant is running.
- Confirm the phone runs iOS 27 or newer for device-initiated RemotePairing.
- Retry the assistant; stale pairing sessions are discarded on app launch.
- Use USB for older iOS versions.

## `pymobiledevice3` is missing

```bash
brew install uv
uv tool install --python 3.13 'pymobiledevice3==9.31.0'
```

Then reopen GeoShift.

## Command-Q is refused

GeoShift stays open when it cannot confirm either a completed clear or a durable
handoff to the background restore queue. Reconnect the iPhone if possible,
choose **Restore GPS**, and quit again after the status updates.

## Collect diagnostics

The in-app diagnostics panel shows the last 50 events. Full rotating logs are at:

```bash
tail -f "$HOME/Library/Logs/GeoShift.log"
launchctl print "gui/$(id -u)/com.lemelson.geoshift.keeper"
```

Before posting logs publicly, redact device identifiers, IP addresses, usernames,
local paths, and any pairing or trust material. Never attach files from
`~/.pymobiledevice3`.

## Report a bug

Include:

- GeoShift version;
- macOS and iOS versions;
- iPhone model;
- USB or Wi-Fi connection type;
- the visible GeoShift state and exact reproduction steps;
- redacted recent diagnostics.

Use a private Security Advisory for suspected security or privacy problems.
