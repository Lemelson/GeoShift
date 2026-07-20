# Contributing to GeoShift

Thank you for helping improve GeoShift. Bug reports, documentation fixes,
compatibility results, translations, and focused code contributions are welcome.

## Before opening an issue

1. Read the [troubleshooting guide](docs/TROUBLESHOOTING.md).
2. Search existing issues.
3. Reproduce with the latest `main` branch when practical.
4. Redact device UDIDs, IP addresses, usernames, local paths, and pairing data.

Use GitHub Security Advisories, not a public issue, for security or privacy bugs.

## Development setup

```bash
brew install uv
uv tool install --python 3.13 'pymobiledevice3==9.31.0'
swift test
PYTHONDONTWRITEBYTECODE=1 uv run --with 'pymobiledevice3==9.31.0' \
  python -m unittest discover -s Tests/Python -v
```

See [Installation](docs/INSTALLATION.md) for the complete setup.

## Pull requests

- Keep changes focused and explain the user-visible behavior.
- Add or update tests for safety-critical worker and state transitions.
- Keep English and Russian UI resources synchronized.
- Do not commit generated `.app` bundles, `.build`, logs, runtime JSON, pairing
  records, credentials, or device identifiers.
- Run `swift test`, the Python test suite, and `git diff --check` before opening
  a pull request.

GeoShift controls a persistent device-side location simulation. Changes to
start, stop, reconnect, process termination, or target-device selection must
fail safe toward a durable Restore GPS request.
