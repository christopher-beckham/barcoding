#!/bin/bash

python fasta2json.py --infile=data/birds/A.fas > A.fas.json
python ../exp03-freq/01-csv.py --outfile=A.fas.csv --outlist=deleteme --kmerrange="3,5" --taxlevel="genus" < A.fas.json
