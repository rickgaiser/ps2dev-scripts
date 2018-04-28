#!/bin/bash

## Enter the toolchain/build directory
mkdir -p toolchain/build
cd toolchain/build

TARG_NAME="iop"
#TARGET="mipsel-ps2-irx"
TARGET="iop"
TARG_XTRA_OPTS="--disable-libstdcxx"
PROC_NR=$(nproc)

## Create and enter the build directory.
rm -rf gcc-$TARG_NAME-stage1 && mkdir gcc-$TARG_NAME-stage1 && cd gcc-$TARG_NAME-stage1 || { exit 1; }

## Configure the build.
../../"$TARG_NAME"/gcc/configure --prefix="$PS2DEV/$TARG_NAME" --target="$TARGET" --enable-languages="c" --disable-nls --disable-shared --disable-libssp --disable-libmudflap --disable-threads --disable-libgomp --disable-libquadmath --disable-target-libiberty --disable-target-zlib --without-ppl --without-cloog --with-headers=no --disable-libada --disable-libatomic --disable-multilib $TARG_XTRA_OPTS || { exit 1; }

## Compile and install.
make clean && make -j $PROC_NR && make install && make clean || { exit 1; }

## Exit the build directory
cd .. || { exit 1; }

## Exit the toolchain/build directory
cd ../.. || { exit 1; }

