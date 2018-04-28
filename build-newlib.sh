#!/bin/bash

## Enter the toolchain/build directory
mkdir -p toolchain/build
cd toolchain/build

TARGET="ee"
PROC_NR=$(nproc)

## Create and enter the build directory.
rm -rf newlib-$TARGET && mkdir newlib-$TARGET && cd newlib-$TARGET || { exit 1; }

## Configure the build.
../../"$TARGET"/newlib/configure --prefix="$PS2DEV/$TARGET" --target="$TARGET" || { exit 1; }

## Compile and install.
make clean && make -j $PROC_NR && make install && make clean || { exit 1; }

## Exit the build directory
cd .. || { exit 1; }

## Exit the toolchain/build directory
cd ../.. || { exit 1; }

