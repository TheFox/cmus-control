#!/usr/bin/env bash

SCRIPT_BASEDIR=$(dirname "$0")

cd "${SCRIPT_BASEDIR}/.."
rm -vrdf build tmp
