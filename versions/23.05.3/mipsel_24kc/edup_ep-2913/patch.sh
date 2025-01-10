#!/bin/bash

# The working direction is the OpenWrt repo root

# Get the location of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$1"

source $ROOT_DIR/scripts/patch-utils.sh

echo "Add U-Boot support for EDUP EP-2913"
NEW_UBOOT_TARGET='define U-Boot/edup_ep-2913
  NAME:=MT7620 Reference Board
  UBOOT_CONFIG:=edup_ep-2913
  BUILD_DEVICES:=edup_ep-2913
  BUILD_TARGET:=ramips
  BUILD_SUBTARGET:=mt7620
  UBOOT_IMAGE:=u-boot-with-spl.bin
endef

'

UBOOT_MAKEFILE=package/boot/uboot-mediatek/Makefile
if ! grep -q edup_ep-2913 "$UBOOT_MAKEFILE"; then
	insert_before_first_occurrence $UBOOT_MAKEFILE 'UBOOT_TARGETS :=' "$NEW_UBOOT_TARGET"
	insert_after_first_occurrence $UBOOT_MAKEFILE 'UBOOT_TARGETS :=' '	edup_ep-2913 \\'

	cp -v $SCRIPT_DIR/uboot.patch package/boot/uboot-mediatek/patches/999-add-edup_ep-2913.patch
fi

echo "Add EDUP EP-2913 Support"

grep -q edup_ep-2913 target/linux/ramips/image/mt7620.mk && exit 0

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
