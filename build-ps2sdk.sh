#!/bin/bash

OSVER=$(uname)

## Determine the maximum number of processes that Make can work with.
## MinGW's Make doesn't work properly with multi-core processors.
if [ ${OSVER:0:10} == MINGW32_NT ]; then
	PROC_NR=2
elif [ ${OSVER:0:6} == Darwin ]; then
	PROC_NR=$(sysctl -n hw.ncpu)
else
	PROC_NR=$(nproc)
fi

## Enter the toolchain/ps2sdk directory
cd toolchain/ps2sdk

# make sure ps2sdk's makefile does not use it
unset PS2SDKSRC

## Build and install
make clean && make -j $PROC_NR && make install || { exit 1; }

## gcc needs to include both libc and libkernel from ps2sdk to be able to build executables.
## NOTE: There are TWO libc libraries, gcc needs to include them both.
ln -sf "$PS2SDK/ee/lib/libc.a"      "$PS2DEV/ee/ee/lib/libps2sdkc.a" || { exit 1; }
ln -sf "$PS2SDK/ee/lib/libkernel.a" "$PS2DEV/ee/ee/lib/libkernel.a" || { exit 1; }

# leave the toolchain/ps2sdk directory
cd ../..

