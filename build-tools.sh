#!/bin/bash
cd tools

cd ps2client
make clean all install
cd ..

cd ps2-packer
make clean all install
cd ..

cd ..
