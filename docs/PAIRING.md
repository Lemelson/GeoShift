# Pairing an iPhone

GeoShift can use trusted USB, legacy Wi-Fi lockdown, or iOS 27+ RemotePairing.
The app always records the exact target iPhone and will not clear another device.

## iOS 27 or newer: pair without a cable

1. Put the Mac and iPhone on the same local Wi-Fi network.
2. Unlock the iPhone and keep GeoShift open.
3. In GeoShift, open **Settings → Connection → Set up Wi-Fi connection**.
4. On iPhone, open **Settings → Developer → Paired Macs**.
5. Under **Other Devices**, tap **GeoShift**.
6. Enter the six-digit code shown by GeoShift.
7. Wait for GeoShift to report that the pairing credentials were saved.

The dedicated GeoShift record is separate from the ordinary MacBook Pro system
pair. Do not delete the existing system pair.

## USB fallback and older iOS versions

1. Connect the unlocked iPhone to the Mac with a data-capable cable.
2. Tap **Trust** on the iPhone and enter the device passcode if requested.
3. Confirm that Finder can see the iPhone.
4. Leave the phone unlocked for the first developer-service connection.
5. Open GeoShift and choose **Reconnect**.

After the first trusted connection, wireless reconnect may work while both
devices remain on the same network.

## How often must pairing be renewed?

Normally once. It is not a weekly, biweekly, or monthly permission.

Pair again only when:

- GeoShift was manually removed from **Paired Macs**;
- the local pairing record was deleted;
- trust or network settings were reset;
- macOS was reinstalled or the user profile was replaced;
- an iOS/macOS update invalidated the record;
- GeoShift explicitly reports invalid pairing credentials.

Restarting either device, locking the iPhone, sleeping the Mac, or reconnecting
to the same Wi-Fi should not require a new six-digit code.

## Network notes

- Both devices must be able to reach each other on the local network.
- Guest Wi-Fi and client-isolation networks often block peer-to-peer traffic.
- VPN and firewall software may block Bonjour or local-network traffic even
  though both devices appear connected to Wi-Fi.
- A delayed Bonjour advertisement is normal; GeoShift waits before declaring
  the phone unavailable and then keeps retrying safely.
