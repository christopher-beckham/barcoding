#!/bin/bash

python 01-csv.py --kmer="3,7" --outfile=$OUT_FOLDER/out.csv --outlist=$OUT_FOLDER/out.list < res.fasta
python 02-write-sh.py < out.list > weka.sh


