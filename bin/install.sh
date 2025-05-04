#!/usr/bin/env bash

SCRIPT_BASEDIR=$(dirname "$0")

cd "${SCRIPT_BASEDIR}/.."

set -e

zig build --release
install zig-out/bin/cmuscontrold /usr/local/bin/

cp skel/at.fox21.cmuscontrold.plist "${HOME}/Library/LaunchAgents/at.fox21.cmuscontrold.plist"
launchctl load "${HOME}/Library/LaunchAgents/at.fox21.cmuscontrold.plist"
