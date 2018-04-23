#!/bin/bash
cd apps

cd ps2link
make clean all
cd ..

cd open-ps2-loader
make clean release
cd ..

cd ..
