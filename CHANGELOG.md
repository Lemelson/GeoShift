# Changelog

All notable changes to GeoShift are documented here.

## 1.5.0 — 2026-07-20

### Added

- English interface by default with an in-app English/Russian language switch.
- Guided iOS 27+ device-initiated Wi-Fi pairing with a six-digit code.
- Durable worker status, exact target-device identity, and pending restore queue.
- Five-minute application heartbeat watchdog and startup recovery.
- Rotating diagnostics with a collapsed last-50-events view.
- Python regression tests for device selection, clear safety, stale heartbeat,
  RemotePairing discovery, and corrupt-configuration recovery.

### Changed

- Restore GPS is now mandatory on normal app termination.
- Command-Q is refused if a safe restore handoff cannot be confirmed.
- RemotePairing discovery waits long enough for delayed Bonjour advertisements.
- City search supports both English and Russian names, countries, and regions.

### Fixed

- A simulated location could remain on the phone after the app or worker stopped.
- A stale worker could overwrite a confirmed clear with `clearPending`.
- A forced worker termination could incorrectly report success before clear.
- Missing or invalid configuration could abandon a device-side simulation.

## 1.0.0

- Initial public release.
