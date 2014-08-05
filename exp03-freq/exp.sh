#!/bin/bash

echo "Using training file: "$OUT_FOLDER/$1.json

python 01-csv.py --kmer="3,5" --taxlevel="genus" --outfile=$OUT_FOLDER/$1.csv --outlist=$OUT_FOLDER/$1.list < $OUT_FOLDER/$1.json
#python 02-write-sh.py < $OUT_FOLDER/out2.list > weka.sh
java -Xmx6000M weka.core.converters.CSVLoader -B `wc -l $OUT_FOLDER_WIN/$1.csv` $OUT_FOLDER_WIN/$1.csv > $OUT_FOLDER/$1.csv.arff
#./weka.sh $OUT_FOLDER_WIN/out.csv.arff > out.csv.arff.results

