# Compatibility

| Component | Supported or expected | Notes |
| --- | --- | --- |
| macOS | 14+ | SwiftUI desktop app and per-user LaunchAgent |
| Swift | 6.2+ | Required by `Package.swift` |
| Python | 3.11–3.13 | Python 3.13 is recommended |
| pymobiledevice3 | 9.31.0 | Installed separately, not bundled |
| Physical iPhone | iOS 17+ | Developer Mode and a trusted Mac are required |
| iOS 27 Wi-Fi pairing | Beta-tested | Device-initiated RemotePairing, no cable required |
| Older iOS pairing | USB first | Later trusted Wi-Fi reconnect may work |
| iOS Simulator | Not targeted | Use Xcode's built-in simulator location controls |
| Apple Silicon | Supported | Primary development platform |
| Intel Mac | Expected | Requires compatible Swift and Python toolchains |

The iOS 27 RemotePairing path has been verified on the current iOS 27 beta over
local Wi-Fi. Apple may change this developer service before or between stable
releases. Compatibility reports are welcome, but redact device identifiers.

## Known limitations

- The app is source-distributed and public builds are not notarized.
- Wi-Fi pairing requires local peer-to-peer connectivity.
- GeoShift changes Core Location coordinates, not public IP or network country.
- Apps can detect developer location simulation or cross-check GPS against IP.
- Apple can change private developer-service behavior between iOS releases.
- A phone restart clears the current developer location simulation. If **Start**
  remains requested and the worker reconnects, GeoShift can apply it again.
