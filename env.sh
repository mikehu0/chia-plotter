#!/bin/sh
sudo apt install git gcc g++ make libtool autoconf libsodium-dev cmake build-essential
git clone https://github.com/gperftools/gperftools
cd gperftools
./autogen.sh 
./configure --enable-frame-pointers
make -j$(nproc)
sudo make install

