#!/bin/bash

len=$1

cd R

Rscript recall-plot.R $OUT_FOLDER_WIN/recall.$len.txt $len