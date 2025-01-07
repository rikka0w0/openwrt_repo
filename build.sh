#!/bin/bash

KEY_PATH=/home/rikka/.ssh/openwrt_repo.pri
SCRIPT_PATH=$(pwd)/scripts
CONFIG_PATH=$(pwd)/configs
REPO_DIR=$(pwd)/releases
OPENWRT_VER=23.05.3

rm -r $REPO_DIR

git clone https://github.com/openwrt/openwrt.git
cd openwrt
git checkout v${OPENWRT_VER}

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

for CONFIG_FILE in "${CONFIG_PATH}"/*; do
	CONFIG_FILE_NAME=$(basename "$CONFIG_FILE")
	PACKAGE_TYPE="${CONFIG_FILE_NAME%.*}"
	PACKAGE_REPO=$REPO_DIR/$OPENWRT_VER/packages/$PACKAGE_TYPE
	
	echo "Build for config: ${CONFIG_FILE}"
	echo "Repo: ${PACKAGE_REPO}"

	cp ${CONFIG_FILE} .config -v
	make tools/compile -j$(nproc)
	make toolchain/compile -j$(nproc)
	make package/network/services/odhcpd/{clean,download,compile} -j$(nproc)

	mkdir -p $PACKAGE_REPO
	cp bin/packages/$PACKAGE_TYPE/base/odhcpd*.ipk $PACKAGE_REPO -v
done

# Make the repo
cd $SCRIPT_PATH
find $REPO_DIR -type f -name "index.html" -delete

./make-index-and-sign.sh -s $KEY_PATH $REPO_DIR
./make-index-html.sh $REPO_DIR
