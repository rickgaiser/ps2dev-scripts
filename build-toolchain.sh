#!/bin/bash


OSVER=$(uname)
## Apple needs to pretend to be linux
if [ ${OSVER:0:6} == Darwin ]; then
	TARG_XTRA_OPTS="--build=i386-linux-gnu --host=i386-linux-gnu --enable-cxx-flags=-G0"
else
	TARG_XTRA_OPTS="--enable-cxx-flags=-G0"
fi


## Determine the maximum number of processes that Make can work with.
## MinGW's Make doesn't work properly with multi-core processors.
if [ ${OSVER:0:10} == MINGW32_NT ]; then
	PROC_NR=2
elif [ ${OSVER:0:6} == Darwin ]; then
	PROC_NR=$(sysctl -n hw.ncpu)
else
	PROC_NR=$(nproc)
fi


## NOTE: Building a new toolchain will also wipe the $PS2DEV folder
rm -rf $PS2DEV/*

## Enter the toolchain/build directory
## NOTE: removes the build directory first!
cd toolchain
rm -rf build
mkdir -p build
cd build


##
## Build binutils
##
for TARGET in "ee" "iop" "dvp"; do
	## Create and enter the build directory.
	mkdir binutils-$TARGET && cd binutils-$TARGET || { exit 1; }

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


##
## Build gcc stage1
##
for TARGET in "ee" "iop"; do
	## Create and enter the build directory.
	mkdir gcc-$TARGET-stage1 && cd gcc-$TARGET-stage1 || { exit 1; }

	## Configure the build.
	if [ ${OSVER:0:6} == Darwin ]; then
		CC=/usr/bin/gcc CXX=/usr/bin/g++ LD=/usr/bin/ld CFLAGS="-O0 -ansi -Wno-implicit-int -Wno-return-type" ../../gcc/configure --prefix="$PS2DEV/$TARGET" --target="$TARGET" --enable-languages="c" --with-newlib --without-headers $TARG_XTRA_OPTS || { exit 1; }
	else
		../../gcc/configure --prefix="$PS2DEV/$TARGET" --target="$TARGET" --enable-languages="c" --with-newlib --without-headers $TARG_XTRA_OPTS || { exit 1; }
	fi

	## Compile and install.
	make clean && make -j $PROC_NR && make install && make clean || { exit 1; }

	## Exit the build directory.
	cd .. || { exit 1; }
done


##
## Build newlib
##
for TARGET in "ee"; do
	## Create and enter the build directory.
	mkdir newlib-$TARGET && cd newlib-$TARGET || { exit 1; }

	## Configure the build.
	../../newlib/configure --prefix="$PS2DEV/$TARGET" --target="$TARGET" || { exit 1; }

	## Compile and install.
	make clean && make -j $PROC_NR && make install && make clean || { exit 1; }

	## Exit the build directory.
	cd .. || { exit 1; }
done


##
## Build gcc stage2
##
for TARGET in "ee"; do
	## Create and enter the build directory.
	mkdir gcc-$TARGET-stage2 && cd gcc-$TARGET-stage2 || { exit 1; }

	## Configure the build.
	../../gcc/configure --prefix="$PS2DEV/$TARGET" --target="$TARGET" --enable-languages="c,c++" --with-newlib --with-headers="$PS2DEV/$TARGET/$TARGET/include" $TARG_XTRA_OPTS || { exit 1; }

	## Compile and install.
	make clean && make -j $PROC_NR && make install && make clean || { exit 1; }

	## Exit the build directory.
	cd .. || { exit 1; }
done


# leave the toolchain/build directory
cd ../..

