## Summary

Describe the user-visible behavior and why the change is needed.

## Verification

- [ ] `swift test`
- [ ] Python worker tests
- [ ] `git diff --check`
- [ ] English and Russian UI resources remain synchronized
- [ ] No generated app/build files, logs, device IDs, local paths, or pairing data

## Safety impact

Explain any effect on Start, Restore GPS, target-device selection, reconnect,
heartbeat, worker termination, or pending-clear behavior. Write “None” when the
change cannot affect those paths.
