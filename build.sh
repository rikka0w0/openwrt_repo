#!/bin/bash

ROOT_DIR=$(pwd)
REPO_DIR=$ROOT_DIR/releases

get_sub_dirs() {
	local sub_dirs=()

	# Find all OpenWrt versions
	while IFS= read -r dir; do
		sub_dirs+=("$(basename "$dir")")
	done < <(find "$1" -maxdepth 1 -mindepth 1 -type d)

	# Return the array as a space-separated string
	echo "${sub_dirs[@]}"
}

OPENWRT_VER_LIST=($(get_sub_dirs "$ROOT_DIR/versions"))

rm -r $REPO_DIR

for OPENWRT_VER in "${OPENWRT_VER_LIST[@]}"; do
	OPENWRT_ROOT=$ROOT_DIR/openwrt-$OPENWRT_VER
	ARCH_LIST=($(get_sub_dirs "$ROOT_DIR/versions/$OPENWRT_VER"))

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

	echo "Building ${OPENWRT_VER}"

	# Discard changes in tracked files
	git reset --hard

	git checkout v${OPENWRT_VER}

	PATCH_LIST=($(find $ROOT_DIR/versions/$OPENWRT_VER -name patch.sh))
	for PATCH_SCRIPT in "${PATCH_LIST[@]}"; do
		echo "Applying patch ${PATCH_SCRIPT}"
		${PATCH_SCRIPT} "$ROOT_DIR"
	done

	for ARCH in "${ARCH_LIST[@]}"; do
		echo "Building ${OPENWRT_VER} for ${ARCH} at ${OPENWRT_ROOT}"

		TASK_LIST=($(get_sub_dirs "$ROOT_DIR/versions/$OPENWRT_VER/$ARCH"))

		for TASK in "${TASK_LIST[@]}"; do
			echo "Running task $TASK BUILD"
			TASK_SCRIPT="$ROOT_DIR/versions/$OPENWRT_VER/$ARCH/$TASK/target.sh"
			#$TASK_SCRIPT BUILD "$ROOT_DIR"
			#$TASK_SCRIPT DEPLOY "$ROOT_DIR" "$OPENWRT_VER" "$ARCH"
		done
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
