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


## Enter the toolchain/build directory
mkdir -p toolchain/build
cd toolchain/build


##
## Build binutils
##
for TARGET in "ee" "iop" "dvp"; do
	## Create and enter the build directory.
	rm -rf binutils-$TARGET && mkdir binutils-$TARGET && cd binutils-$TARGET || { exit 1; }

	## Configure the build.
	if [ ${OSVER:0:6} == Darwin ]; then
		CC=/usr/bin/gcc CXX=/usr/bin/g++ LD=/usr/bin/ld CFLAGS="-O0 -ansi -Wno-implicit-int -Wno-return-type" ../../binutils/configure --prefix="$PS2DEV/$TARGET" --target="$TARGET" || { exit 1; }
	else
		../../binutils/configure --prefix="$PS2DEV/$TARGET" --target="$TARGET" || { exit 1; }
	fi

	## Compile and install.
	make clean && make -j $PROC_NR CFLAGS="$CFLAGS -D_FORTIFY_SOURCE=0" && make install && make clean || { exit 1; }

	## Exit the build directory.
	cd .. || { exit 1; }
done


# leave the toolchain/build directory
cd ../..
