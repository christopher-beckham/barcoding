#!/bin/bash


export CLUSTALO=`realpath deps/clustal-omega-1.2.1/src/clustalo.exe`

# If you're on a Unix system, make EXP_SHARED_WIN = EXP_SHARED
# and OUT_FOLDER_WIN = OUT_FOLDER.

export EXP_SHARED=`realpath exp-shared`
export EXP_SHARED_WIN=`cygpath -w $EXP_SHARED`

export OUT_FOLDER=`realpath exp-shared/output`
export OUT_FOLDER_WIN=`cygpath -w $OUT_FOLDER`
