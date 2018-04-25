#!/bin/bash


## Determine the maximum number of processes that Make can work with.
## MinGW's Make doesn't work properly with multi-core processors.
if [ ${OSVER:0:10} == MINGW32_NT ]; then
	PROC_NR=2
elif [ ${OSVER:0:6} == Darwin ]; then
	PROC_NR=$(sysctl -n hw.ncpu)
else
	PROC_NR=$(nproc)
fi


## Enter the toolchain/build directory
## NOTE: removes the build directory first!
mkdir -p toolchain/build
cd toolchain/build


##
## Build newlib
##
for TARGET in "ee"; do
	## Create and enter the build directory.
	rm -rf newlib-$TARGET && mkdir newlib-$TARGET && cd newlib-$TARGET || { exit 1; }

	## Configure the build.
	../../newlib/configure --prefix="$PS2DEV/$TARGET" --target="$TARGET" || { exit 1; }

	## Compile and install.
	make clean && make -j $PROC_NR && make install && make clean || { exit 1; }

	## Exit the build directory.
	cd .. || { exit 1; }
done


# leave the toolchain/build directory
cd ../..
