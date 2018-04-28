#!/bin/bash
./build-binutils-iop.sh || { exit 1; }
./build-gcc-iop-stage1.sh || { exit 1; }
./build-ps2sdk.sh || { exit 1; }
./build-libs.sh || { exit 1; }
./build-apps.sh || { exit 1; }
ps2client -h 192.168.1.10 execee host:apps/open-ps2-loader/OPNPS2LD.ELF || { exit 1; }

