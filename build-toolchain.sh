#!/bin/bash

## NOTE: Building a new toolchain will also wipe the $PS2DEV folder
rm -rf $PS2DEV/*
rm -rf toolchain/build

./build-binutils-ee.sh    || { exit 1; }
./build-binutils-iop.sh   || { exit 1; }
./build-binutils-dvp.sh   || { exit 1; }
./build-gcc-ee-stage1.sh  || { exit 1; }
./build-gcc-iop-stage1.sh || { exit 1; }
./build-newlib.sh         || { exit 1; }
./build-gcc-ee-stage2.sh  || { exit 1; }
