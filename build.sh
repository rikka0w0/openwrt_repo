#!/bin/bash

CONFIG_PATH=$(pwd)/configs

git clone https://github.com/openwrt/openwrt.git
cd openwrt
git checkout v23.05.3

# Define the Makefile path
MAKEFILE="package/network/services/odhcpd/Makefile"

# Replace PKG_SOURCE_URL line
sed -i 's|^PKG_SOURCE_URL=.*|PKG_SOURCE_URL=https://github.com/rikka0w0/odhcpd.git|' "$MAKEFILE"

# Update PKG_SOURCE_VERSION
sed -i 's|\(PKG_SOURCE_VERSION:=\).*|\1e0c6642e306ac4cfae879660b0acb901552f16d3|' "$MAKEFILE"

# Update PKG_MIRROR_HASH
sed -i 's|\(PKG_MIRROR_HASH:=\).*|\1361efbf7110601e769ceed5c74b2e9f663b2fe265e6fb39c9fa2fc83a0b2b406|' "$MAKEFILE"

for CONFIG_FILE in "${CONFIG_PATH}"/*; do
	echo "Build for config: ${CONFIG_FILE}"

	cp ${CONFIG_FILE} .config -v
	make tools/compile -j$(nproc)
	make toolchain/compile -j$(nproc)
	make package/network/services/odhcpd/{clean,download,compile} -j$(nproc)
done
