#!/usr/bin/env bash

SCRIPT_BASEDIR=$(dirname "$0")

which make &> /dev/null || { echo 'ERROR: make not found in PATH' >&2; exit 1; }

cd "${SCRIPT_BASEDIR}/.."
pwd

set -x

mkdir -p build/release
cd build/release

cmake -DCMAKE_BUILD_TYPE=Release ../..
make launchctl_unload
