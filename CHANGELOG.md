# Changelog

All notable changes to GeoShift are documented here.

## Unreleased

### Fixed

- Fresh backend installs no longer resolve `pmd-pytcp` 0.1.0 or newer, whose
  async API breaks pymobiledevice3 9.31.0's userspace tunnel and floods the log
  with `asyncio.queues.QueueFull` ([#4](https://github.com/Lemelson/GeoShift/issues/4)).
  Installation, test, and CI commands now pin `pmd-pytcp>=0.0.4,<0.1.0`.

### Added

- The worker detects an incompatible `pmd-pytcp` before opening a tunnel, logs
  the repair command once a minute instead of looping on `QueueFull`, and the
  app shows a dedicated status message.

## 1.5.2 — 2026-07-21

### Added

- A compact English/Russian language switch in the main window header.
- Apple emoji flags in both the main-window and Settings language controls.

### Changed

- The default window height now fits the collapsed interface instead of leaving
  a large empty area below Diagnostics.
- Expanded diagnostics remain bounded inside their own scrolling log panel, and
  the main window can still be resized vertically.

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
