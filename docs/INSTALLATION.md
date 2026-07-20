# Installation

GeoShift is currently distributed as source code. The install script builds an
ad-hoc signed macOS app, copies it to `/Applications`, and opens it.

## Requirements

- macOS 14 or newer
- Apple Silicon or Intel Mac capable of running Swift 6.2
- Xcode 26 or a Swift 6.2 toolchain
- Python 3.11–3.13
- `pymobiledevice3` 9.31.0
- a physical iPhone with Developer Mode enabled

GeoShift does not target the iOS Simulator. Xcode already includes location
simulation controls for simulator devices.

## Install the backend

The recommended installation keeps `pymobiledevice3` isolated with `uv`:

```bash
brew install uv
uv tool install --python 3.13 'pymobiledevice3==9.31.0'
```

GeoShift also checks common Homebrew, pipx, and local-bin locations.

## Build and install GeoShift

```bash
git clone https://github.com/Lemelson/GeoShift.git
cd GeoShift
./Scripts/install_app.sh
```

The resulting app is `/Applications/GeoShift.app`.

## First launch and Gatekeeper

Public builds are ad-hoc signed but not notarized. If macOS blocks the first
launch, Control-click **GeoShift.app** in Finder, choose **Open**, and confirm.
You normally do this once for a particular build.

Do not disable Gatekeeper globally.

## Developer Mode on iPhone

On the iPhone, open **Settings → Privacy & Security → Developer Mode** and follow
the restart/confirmation flow. Apple may ask you to reconfirm Developer Mode
after some iOS updates.

Continue with the [pairing guide](PAIRING.md).

## Build without installing

```bash
swift test
./Scripts/package_app.sh release
```

The packaged app is written to `GeoShift.app` in the repository root and is
ignored by Git.
