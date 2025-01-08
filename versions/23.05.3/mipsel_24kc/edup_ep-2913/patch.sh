#!/bin/bash

# The working direction is the OpenWrt repo root

# Get the location of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Add EDUP EP-2913 Support"

sed -i '/dlink,dch-m225|\\/a\\tedup,ep-2913|\\' target/linux/ramips/mt7620/base-files/etc/board.d/02_network

cat <<- 'EOF' >> target/linux/ramips/image/mt7620.mk
define Device/edup_ep-2913
	SOC := mt7620n
	IMAGE_SIZE := 7872k
	DEVICE_VENDOR := EDUP
	DEVICE_MODEL := EP-2913
	DEVICE_PACKAGES := kmod-usb2 kmod-usb-ohci
	SUPPORTED_DEVICES += ep-2913
endef
TARGET_DEVICES += edup_ep-2913
EOF

cp -v $SCRIPT_DIR/mt7620n_edup_ep-2913.dts target/linux/ramips/dts/mt7620n_edup_ep-2913.dts
