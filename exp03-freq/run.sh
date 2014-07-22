#!/bin/bash

python $EXP_SHARED/gen-params.py $EXP03_KMER_MIN","$EXP03_KMER_MAX","$EXP03_KMER_STEP "0,0,1" | parallel --colsep ' ' --max-procs=1 --bar 'python 01-csv.py --kmer={1} < res.fasta > $OUT_FOLDER/kmer.{1}.csv'


