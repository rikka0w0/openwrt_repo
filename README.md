# Introduction
This repository provides some packages and firmwares that are not officially supported (not supported by OpenWrt official, e.g. 8M/64M devices) and/or contains not yet merged patches.

A Package could be removed from this repository. If so, please use the package from the official repository. The most likely reason is that all related patches have been merged into the official branch.

1. The odhcp package in this repo supports IPv6 Pxe. [The patch](https://github.com/openwrt/odhcpd/pull/227) is waiting to be merged as of Jan 2025.

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
echo 'src/gz rikka0w0 https://rikka0w0.github.io/openwrt_repo/$VERSION/packages/mips_mips32/' >> /etc/opkg/customfeeds.conf

# Update opkg feed
opkg update
```
