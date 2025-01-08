#!/bin/bash

# The working direction is the OpenWrt repo root

# Get the location of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$1"

find "$ROOT_DIR/packages/" -name "*.sh" -exec sh -c 'sh "$0" PATCH' {} \;
