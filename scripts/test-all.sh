#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ls -1 ./images/ | xargs -I {} ${SCRIPT_DIR}/test-image.sh {}
