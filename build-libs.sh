#!/bin/bash
CMAKE_OPTIONS="-Wno-dev -DCMAKE_TOOLCHAIN_FILE=../../ps2dev.cmake -DCMAKE_INSTALL_PREFIX=$PS2SDK/ports -DBUILD_SHARED_LIBS=OFF "
#CMAKE_OPTIONS+="-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON "

function build {
    mkdir $1
    cd $1
    cmake $CMAKE_OPTIONS $2 ../../$1 || { exit 1; }
    make clean all || { exit 1; }
    make install || { exit 1; }
    cd ..
}

cd libs

##
## Build libjpeg and libtiff from ps2sdk-ports
##
cd ps2sdk-ports/libjpeg
make clean all install || { exit 1; }
cd ../libtiff
make clean all install || { exit 1; }
cd ../..

##
## Build cmake projects
##
rm -rf build
mkdir build
cd build
build zlib
build libpng "-DPNG_SHARED=OFF -DPNG_STATIC=ON"
build freetype
build libconfig "-DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF"
cd ..

##
## Build gsKit
##
cd gsKit
export LIBJPEG=$PS2SDK/ports
export LIBPNG=$PS2SDK/ports
export ZLIB=$PS2SDK/ports
#export LIBTIFF=$PS2SDK/ports
make clean all install || { exit 1; }
cd ..

cd ..
