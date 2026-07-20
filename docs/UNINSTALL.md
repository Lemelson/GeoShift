# Uninstall GeoShift

First open GeoShift, choose **Restore GPS**, and wait for **Simulation cleared**.
If the phone cannot connect, restart the iPhone before removing the restore queue.

Then quit GeoShift and remove:

```bash
launchctl bootout "gui/$(id -u)/com.lemelson.geoshift.keeper" 2>/dev/null || true
rm -f "$HOME/Library/LaunchAgents/com.lemelson.geoshift.keeper.plist"
rm -rf "/Applications/GeoShift.app"
rm -rf "$HOME/Library/Application Support/GeoShift"
rm -f "$HOME/Library/Logs/GeoShift.log"*
```

Those commands remove the app, worker definition, configuration, status, and
logs. They do not remove `pymobiledevice3` or its other device records.

To remove only the dedicated GeoShift RemotePairing record, use pymobiledevice3's
pair-management command or remove the matching device entry from iPhone
**Settings → Developer → Paired Macs**. Do not delete unrelated pairing files.

To remove the isolated backend installation:

```bash
uv tool uninstall pymobiledevice3
```
