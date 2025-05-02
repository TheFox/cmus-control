#!/usr/bin/env bash

SCRIPT_BASEDIR=$(dirname "$0")

cd "${SCRIPT_BASEDIR}/.."

SDK=$(xcrun --sdk macosx --show-sdk-path)
echo "SDK: ${SDK}"

zig build --release -Dbuildall=true
