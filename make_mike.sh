#!/bin/bash

rm -rf build
mkdir -p build
git submodule update --init

cd build

cmake -D CMAKE_CXX_FLAGS="-O3 -fmax-errors=1 -ltcmalloc -flto -foptimize-strlen" -DARITH="easy" -DBUILD_BLS_PYTHON_BINDINGS=false -DBUILD_BLS_TESTS=false -DBUILD_BLS_BENCHMARKS=false ..

make -j$(nproc) $@

