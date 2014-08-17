#!/bin/bash

FILE="res50k"
echo "Creating $FILE.arff from $FILE.json"
python 01-csv-new.py --kmer="3,5" --taxlevel="genus" --outfile=$OUT_FOLDER/$FILE.arff --outlist=null --infile=$OUT_FOLDER/$FILE.json --maxclass=300