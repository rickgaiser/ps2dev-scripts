#!/bin/bash

TARG_NAME="ee"
TARGET="ee"

TARG_XTRA_OPTS=""
PROC_NR=$(nproc)

## Enter the toolchain/build directory
mkdir -p toolchain/build
cd toolchain/build

## Create and enter the build directory.
rm -rf gcc-$TARG_NAME-stage1 && mkdir gcc-$TARG_NAME-stage1 && cd gcc-$TARG_NAME-stage1 || { exit 1; }

## Configure the build.
../../$TARG_NAME/gcc/configure --prefix="$PS2DEV/$TARG_NAME" --target="$TARGET" --enable-languages="c" --with-newlib --without-headers $TARG_XTRA_OPTS || { exit 1; }

## Compile and install.
make clean && make -j $PROC_NR && make install && make clean || { exit 1; }

## Exit the build directory
cd .. || { exit 1; }

## Exit the toolchain/build directory
cd ../.. || { exit 1; }
