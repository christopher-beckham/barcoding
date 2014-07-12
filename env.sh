#!/bin/bash

if [ -n $(command -v "parallel") ]; then
	echo "yay"
fi

export CLUSTALO=`realpath deps/clustal-omega-1.2.1/src/clustalo.exe`
export EXP01_NUCLIMIT=3000
export EXP01_FRAGLEN=100 # use 0 if you don't want randomly sampled fragments!
export OUT_FOLDER="/cygdrive/g/barcoding/output"
export OUT_FOLDER_WIN="G:/barcoding/output"