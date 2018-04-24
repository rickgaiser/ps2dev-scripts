#!/bin/bash
./build-toolchain.sh || { exit 1; }
./build-ps2sdk.sh || { exit 1; }
./build-tools.sh || { exit 1; }
./build-libs.sh || { exit 1; }
./build-apps.sh || { exit 1; }

