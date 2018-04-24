#!/bin/bash
cd tools

cd ps2client
make clean all install || { exit 1; }
cd ..

cd ps2-packer
make clean all install || { exit 1; }
cd ..

cd ..
