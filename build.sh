#!/bin/bash

ROOT_DIR=$(pwd)
REPO_DIR=$ROOT_DIR/releases
OPENWRT_ROOT=$ROOT_DIR/openwrt
OPENWRT_VER_LIST=(23.05.3)

rm -r $REPO_DIR

if [ -d "$OPENWRT_ROOT" ]; then
	echo 'Found existing OpenWrt repo clone'

	# OpenWrt repo exists
	cd "$OPENWRT_ROOT"

	# Discard changes in tracked files
	git reset --hard

	# Remove all untrack files
	git clean -fd

	# Fetch all tags
	git fetch --tags
else
	git clone https://github.com/openwrt/openwrt.git "$OPENWRT_ROOT"
	cd "$OPENWRT_ROOT"
fi

function build_stage() {
	for script in "$ROOT_DIR/packages"/*; do
		if [[ -f "$script" && -x "$script" ]]; then
			echo "$script"
			"$script" "$@"
		fi
	done
}

for OPENWRT_VER in "${OPENWRT_VER_LIST[@]}"; do
	echo "Building ${OPENWRT_VER}"

	# Discard changes in tracked files
	git reset --hard

	git checkout v${OPENWRT_VER}

	for CONFIG_FILE in "$ROOT_DIR/configs"/*; do
		CONFIG_FILE_NAME=$(basename "$CONFIG_FILE")
		PACKAGE_TYPE="${CONFIG_FILE_NAME%.*}"
		PACKAGE_REPO=$REPO_DIR/$OPENWRT_VER/packages/$PACKAGE_TYPE

		echo "Build for config: ${CONFIG_FILE}"
		echo "Repo: ${PACKAGE_REPO}"

		cp ${CONFIG_FILE} .config -v

		build_stage PATCH

		make tools/compile -j$(nproc)
		make toolchain/compile -j$(nproc)

		build_stage BUILD

		mkdir -p $PACKAGE_REPO
		build_stage DEPLOY $PACKAGE_TYPE $PACKAGE_REPO
	done
done

# Make the repo
cd $ROOT_DIR/scripts
find $REPO_DIR -type f -name "index.html" -delete

./make-index-and-sign.sh -s $ROOT_DIR/private.key $REPO_DIR

cp $ROOT_DIR/public.key $REPO_DIR

HOME_PAGE=$REPO_DIR/index.md
cp $ROOT_DIR/README.md $HOME_PAGE
echo '' >> $HOME_PAGE
echo '# OpenWrt Versions' >> $HOME_PAGE

INDEX=1
for OPENWRT_VER in "${OPENWRT_VER_LIST[@]}"; do
	./make-index-html.sh $REPO_DIR/$OPENWRT_VER

	echo "$INDEX. [$OPENWRT_VER]($OPENWRT_VER)" >> $HOME_PAGE
	((INDEX++))
done
