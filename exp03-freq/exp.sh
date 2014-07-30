#!/bin/bash

python 01-csv.py --kmer="3,5" --outfile=$OUT_FOLDER/out.csv --outlist=$OUT_FOLDER/out.list < $EXP_SHARED/res.fasta
python 02-write-sh.py < $OUT_FOLDER/out.list > weka.sh
java -Xmx6000M weka.core.converters.CSVLoader -B `wc -l $OUT_FOLDER/out.csv` $OUT_FOLDER_WIN/out.csv > $OUT_FOLDER/out.csv.arff
./weka.sh $OUT_FOLDER_WIN/out.csv.arff

