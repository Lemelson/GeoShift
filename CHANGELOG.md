# Changelog

All notable changes to GeoShift are documented here.

## 1.5.1 — 2026-07-21

### Fixed

- A timed-out `launchctl` status check could block the app's only monitoring task,
  freeze the UI on “Simulation active,” and stop its heartbeat.
- The five-minute crash watchdog could consequently restore real GPS while the
  GeoShift window was still open and Start was still selected.
- Command timeouts now return promptly, terminate the child process, and cannot
  strand later commands behind an uncancellable synchronous wait.
- Worker crash detection now requires both a stale heartbeat and a released
  process-liveness lease, so an alive but delayed or suspended app cannot trigger
  an unwanted GPS restore.
- The liveness lease now passes a decoded Application Support path to the POSIX
  lock API instead of treating the encoded `%20` path as a real directory.
- Start retries a liveness-lease acquisition after a concurrent crash cleanup
  finishes, without requiring the app to be relaunched.
- Monitoring is owned by the app controller and refreshes immediately when the
  app becomes active instead of depending on a single view task.

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
