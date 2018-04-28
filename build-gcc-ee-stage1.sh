#!/bin/bash

## Enter the toolchain/ee/gcc directory
cd toolchain/ee/gcc

TARGET="ee"
TARG_XTRA_OPTS=""
PROC_NR=$(nproc)

## Create and enter the build directory.
rm -rf gcc-$TARGET-stage1 && mkdir gcc-$TARGET-stage1 && cd gcc-$TARGET-stage1 || { exit 1; }

## Configure the build.
../configure --prefix="$PS2DEV/$TARGET" --target="$TARGET" --enable-languages="c" --with-newlib --without-headers $TARG_XTRA_OPTS || { exit 1; }

## Compile and install.
make clean && make -j $PROC_NR && make install && make clean || { exit 1; }

## Exit the build directory
cd .. || { exit 1; }

## Exit the toolchain/ee/gcc directory
cd ../../.. || { exit 1; }

