#!/bin/bash
cd apps

cd ps2link
make clean all || { exit 1; }
cd ..

cd open-ps2-loader
make clean release || { exit 1; }
cd ..

cd ..
