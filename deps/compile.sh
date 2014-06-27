#!/bin/bash

tar -vxzf argtable2-13.tar.gz
tar -vxzf clustal-omega-1.2.1.tar.gz

echo "Compiling argtable2-13..."

cd argtable2-13
./configure
make

echo "Compiling clustalo..."

cd ..
cd clustal-omega-1.2.1

./configure CFLAGS="-I"`realpath ../argtable2-13/src` LDFLAGS="-L"`realpath ../argtable2-13/src/.libs`
make