#!/bin/bash

# https://github.com/openwrt/odhcpd/pull/227

# The working direction is the OpenWrt repo root

# Get the location of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# $1 is the build stage
case "$1" in
	"BUILD")
		make world -j$(nproc)
		;;

	"DEPLOY")
		ROOT_DIR=$2
		OPENWRT_VER=$3
		ARCH=$4
		DST_DIR=$ROOT_DIR/releases/$OPENWRT_VER/targets/ramips/mt7620
		echo "Deploy to $ROOT_DIR/releases/$OPENWRT_VER/targets/ramips/mt7620"
		# cp bin/packages/$PACKAGE_TYPE/base/odhcpd*.ipk $PACKAGE_REPO -v
		;;
esac