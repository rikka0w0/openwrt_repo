#!/bin/bash

# https://github.com/openwrt/odhcpd/pull/227

# The working direction is the OpenWrt repo root

# Get the location of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ROOT_DIR=$1
OPENWRT_VER=$2
ARCH=$3
TARGET=$4

make world -j$(nproc)

DST_DIR=$ROOT_DIR/releases/$OPENWRT_VER/targets/ramips/mt7620
echo $DST_DIR
#cp -v bin/target/ramips/mt7620 $PACKAGE_REPO -v
