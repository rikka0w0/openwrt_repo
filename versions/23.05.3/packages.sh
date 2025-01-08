#!/bin/bash

# The working direction is the OpenWrt repo root

# Get the location of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$1"
OPENWRT_VER="$2"
ARCH="$3"

PACKAGE_REPO=$ROOT_DIR/releases/$OPENWRT_VER/packages/$ARCH
mkdir -p $PACKAGE_REPO

cp -v $ROOT_DIR/versions/$OPENWRT_VER/$ARCH/packages.config .config
make tools/compile -j$(nproc)
make toolchain/compile -j$(nproc)

$ROOT_DIR/packages/odhcpd_ipv6_pxe.sh BUILD $ARCH $PACKAGE_REPO
