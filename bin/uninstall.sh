#!/usr/bin/env bash

SCRIPT_BASEDIR=$(dirname "$0")

cd "${SCRIPT_BASEDIR}/.."

launchctl unload "${HOME}/Library/LaunchAgents/at.fox21.cmuscontrold.plist"
rm -f "${HOME}/Library/LaunchAgents/at.fox21.cmuscontrold.plist"

rm -f /usr/local/bin/cmuscontrold
