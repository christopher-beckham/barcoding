#!/bin/bash

# binary release of clustalo caused segfaults, so on cygwin
# we're compiling clustalo ourselves
if [ "$(expr substr $(uname -s) 1 6)" == "CYGWIN" ]; then
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
else
	echo "placeholder"
fi