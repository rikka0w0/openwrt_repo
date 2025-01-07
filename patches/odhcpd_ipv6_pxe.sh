#!/bin/bash

# https://github.com/openwrt/odhcpd/pull/227

# The working direction is the OpenWrt repo root

# $1 is the build stage
case "$1" in
	"PATCH")
		# Define the Makefile path
		MAKEFILE="package/network/services/odhcpd/Makefile"

		# Replace PKG_SOURCE_URL line
		sed -i 's|^PKG_SOURCE_URL=.*|PKG_SOURCE_URL=https://github.com/rikka0w0/odhcpd.git|' "$MAKEFILE"

		# Update PKG_SOURCE_DATE
		sed -i 's|\(PKG_SOURCE_DATE:=\).*|\12025-01-06|' "$MAKEFILE"

		# Update PKG_SOURCE_VERSION
		sed -i 's|\(PKG_SOURCE_VERSION:=\).*|\1e0c6642e306ac4cfae879660b0acb901552f16d3|' "$MAKEFILE"

		# Update PKG_MIRROR_HASH
		sed -i 's|\(PKG_MIRROR_HASH:=\).*|\1361efbf7110601e769ceed5c74b2e9f663b2fe265e6fb39c9fa2fc83a0b2b406|' "$MAKEFILE"
		;;

	"DEPLOY")
		PACKAGE_TYPE=$2
		PACKAGE_REPO=$3
		cp bin/packages/$PACKAGE_TYPE/base/odhcpd*.ipk $PACKAGE_REPO -v
		;;
esac