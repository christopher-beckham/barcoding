#!/bin/bash

if [ -n $(command -v "parallel") ]; then
	echo "yay"
fi

export CLUSTALO=`realpath deps/clustal-omega-1.2.1/src/clustalo.exe`
# export GEN_PARAMS=`realpath exp-shared/gen-params.py`
export EXP_SHARED=`realpath exp-shared`
export EXP_SHARED_WIN=`cygpath -w $EXP_SHARED`

# TODO: clean these up, perhaps have some of these in an exp01-specific env.sh

# Because we're using Cygwin, some programs will expect Windows paths and
# some will expect Unix-like paths. If running these scripts on Unix, make
# both variables the same.

#export OUT_FOLDER_WIN=`realpath output`
export OUT_FOLDER=`realpath output`
export OUT_FOLDER_WIN=`cygpath -w $OUT_FOLDER`
