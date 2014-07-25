#!/bin/bash

if [ -n $(command -v "parallel") ]; then
	echo "yay"
fi

export CLUSTALO=`realpath deps/clustal-omega-1.2.1/src/clustalo.exe`
# export GEN_PARAMS=`realpath exp-shared/gen-params.py`
export EXP_SHARED=`realpath exp-shared`
export EXP_SHARED_WIN=`cygpath -w $EXP_SHARED`

# TODO: clean these up, perhaps have some of these in an exp01-specific env.sh

export EXP01_NUCLIMIT=10000
export EXP01_FRAGLEN=100 # use 0 if you don't want randomly sampled fragments!

# Because we're using Cygwin, some programs will expect Windows paths and
# some will expect Unix-like paths. If running these scripts on Unix, make
# both variables the same.

export OUT_FOLDER_WIN="G:/barcoding/output"
export OUT_FOLDER="/cygdrive/g/barcoding/output"
