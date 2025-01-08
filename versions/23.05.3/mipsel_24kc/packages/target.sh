#!/bin/bash

# The working direction is the OpenWrt repo root

# Get the location of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# $1 is the build stage
case "$1" in
	"BUILD")
		cp -v $SCRIPT_DIR/.config .config
		make tools/compile -j$(nproc)
		make toolchain/compile -j$(nproc)
		find "$ROOT_DIR/packages/" -name "*.sh" -exec sh -c 'sh "$0" BUILD' {} \;
		;;

	"DEPLOY")
		;;
esac

$ROOT_DIR/packages/odhcpd_ipv6_pxe.sh "$@"