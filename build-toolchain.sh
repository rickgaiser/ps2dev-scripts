#!/bin/bash

## NOTE: Building a new toolchain will also wipe the $PS2DEV folder
rm -rf $PS2DEV/*
rm -rf toolchain/build

./build-binutils.sh || { exit 1; }
./build-gcc-stage1.sh || { exit 1; }
./build-newlib.sh || { exit 1; }
./build-gcc-stage2.sh || { exit 1; }
