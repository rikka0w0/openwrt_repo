#! /usr/bin/env bash
set -eu

# Get the full path to the script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

usage_exit() {
	echo "Usage: $0 [-s USIGN_SECRET] TARGET_DIR" 1>&2
	exit 1
}

while getopts K:iv:s:h OPT
do
	case $OPT in
		s)  USIGN_SECRET_PATH=$OPTARG
			;;
		h)  usage_exit
			;;
		\?) usage_exit
			;;
	esac
done

export PATH=$(realpath $SCRIPT_DIR):$PATH

shift $((OPTIND - 1))

if [[ -v USIGN_SECRET_PATH ]] ; then
	USIGN_SECRET_PATH=$(realpath $USIGN_SECRET_PATH)
fi
TARGET_DIR=${1:-.}

make_index_and_sign() {
	local CURRENT_DIR=`pwd`
	echo $1
	cd $1
	$SCRIPT_DIR/ipkg-make-index.sh . > ./Packages
	gzip -9c ./Packages > ./Packages.gz
	if [[ -v USIGN_SECRET_PATH ]] ; then
		$SCRIPT_DIR/usign -S -m ./Packages -s $USIGN_SECRET_PATH -x ./Packages.sig
		$SCRIPT_DIR/usign -S -m ./Packages.gz -s $USIGN_SECRET_PATH -x ./Packages.gz.sig
 	fi
	cd $CURRENT_DIR
}

for dir in $(find $TARGET_DIR -name '*.ipk' -exec dirname {} \; | sort | uniq); do
	make_index_and_sign $dir
done
