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
target_names=("ee" "iop" "dvp")
#targets=("ee" "mipsel-ps2-irx" "dvp")
targets=("ee" "iop" "dvp")
extra_opts=("" "" "")
for ((i=0; i<${#target_names[@]}; i++)); do
	TARG_NAME=${target_names[i]}
	TARGET=${targets[i]}
	TARG_XTRA_OPTS=${extra_opts[i]}

	## Create and enter the build directory.
	rm -rf binutils-$TARG_NAME && mkdir binutils-$TARG_NAME && cd binutils-$TARG_NAME || { exit 1; }

	## Configure the build.
	../../"$TARG_NAME"/binutils/configure --prefix="$PS2DEV/$TARG_NAME" --target="$TARGET" $TARG_XTRA_OPTS || { exit 1; }

	## Compile and install.
	make clean && make -j $PROC_NR CFLAGS="$CFLAGS -D_FORTIFY_SOURCE=0" && make install && make clean || { exit 1; }

	## Exit the build directory.
	cd .. || { exit 1; }
done


# leave the toolchain/build directory
cd ../..
