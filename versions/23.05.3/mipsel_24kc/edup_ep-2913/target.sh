#!/bin/bash

# https://github.com/openwrt/odhcpd/pull/227

# The working direction is the OpenWrt repo root

# Get the location of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ROOT_DIR=$1
OPENWRT_VER=$2
ARCH=$3
TARGET=$4

cp -v $ROOT_DIR/versions/$OPENWRT_VER/$ARCH/$TARGET/.config .config
make -j$(nproc)

DST_DIR=$ROOT_DIR/releases/$OPENWRT_VER/targets/ramips/mt7620
mkdir -p $DST_DIR

echo $DST_DIR
cp -rv bin/targets/ramips/mt7620/* $DST_DIR -v
