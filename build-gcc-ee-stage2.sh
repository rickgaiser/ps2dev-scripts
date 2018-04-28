#!/bin/bash

## Enter the toolchain/ee/gcc directory
cd toolchain/ee/gcc

TARGET="ee"
TARG_XTRA_OPTS="--enable-cxx-flags=-G0"
PROC_NR=$(nproc)

## Create and enter the build directory.
rm -rf gcc-$TARGET-stage2 && mkdir gcc-$TARGET-stage2 && cd gcc-$TARGET-stage2 || { exit 1; }

## Configure the build.
../configure --prefix="$PS2DEV/$TARGET" --target="$TARGET" --enable-languages="c,c++" --with-newlib --with-headers="$PS2DEV/$TARGET/$TARGET/include" $TARG_XTRA_OPTS || { exit 1; }

## Compile and install.
make clean && make -j $PROC_NR && make install && make clean || { exit 1; }

## Exit the build directory
cd .. || { exit 1; }

## Exit the toolchain/ee/gcc directory
cd ../../.. || { exit 1; }

