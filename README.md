# Introduction
This repository provides some packages and firmwares that are not officially supported (not supported by OpenWrt official, e.g. 8M/64M devices) and/or contains not yet merged patches.

A Package could be removed from this repository. If so, please use the package from the official repository. The most likely reason is that all related patches have been merged into the official branch.

1. The odhcp package in this repo supports IPv6 PxE. [The patch](https://github.com/openwrt/odhcpd/pull/227) is waiting to be merged as of Jan 2025.
2. Build [OpenWrt image](https://forum.openwrt.org/t/mt7620n-openwrt-ram-boot-works-but-stuck-just-before-mounting-the-ram-disk/195751/8) and [U-Boot](https://github.com/u-boot/u-boot/pull/663) for [EDUP EP-2913](https://szedup.en.made-in-china.com/product/MbqxXNzVfKhQ/China-WiFi-Wireless-802-11b-G-N-300Mbps-Signal-Repeater-WiFi-Booster-EP-2913-.html). The original device comes with 4M/32M of flash and RAM. An upgrade to 8M/64M is required to install this image.

# Usage
You need to add and trust the public key of this repo before you can use it (Replace `$VERSION` with a supported OpenWrt version, e.g. `23.05.3`):
```sh
# Add the public key
wget -O /tmp/public.key https://rikka0w0.github.io/openwrt_repo/public.key
opkg-key add /tmp/public.key
rm /tmp/public.key

# Check if you have added this repo already
grep -q rikka0w0 /etc/opkg/customfeeds.conf

# Add the repo
echo 'src/gz rikka0w0 https://rikka0w0.github.io/openwrt_repo/$VERSION/packages/$ARCH/' >> /etc/opkg/customfeeds.conf

# Update opkg feed
opkg update
```

To find out value for `$ARCH`, click one of the links below: