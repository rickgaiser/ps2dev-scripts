#!/bin/bash

TARG_NAME="iop"
TARGET="iop"

TARG_XTRA_OPTS=""
PROC_NR=$(nproc)

## Enter the toolchain/build directory
mkdir -p toolchain/build
cd toolchain/build

## Create and enter the build directory.
rm -rf binutils-$TARG_NAME && mkdir binutils-$TARG_NAME && cd binutils-$TARG_NAME || { exit 1; }

## Configure the build.
../../$TARG_NAME/binutils/configure --prefix="$PS2DEV/$TARG_NAME" --target="$TARGET" $TARG_XTRA_OPTS || { exit 1; }

## Compile and install.
make clean && make -j $PROC_NR CFLAGS="$CFLAGS -D_FORTIFY_SOURCE=0" && make install && make clean || { exit 1; }

## Exit the build directory.
cd .. || { exit 1; }

# leave the toolchain/build directory
cd ../..
