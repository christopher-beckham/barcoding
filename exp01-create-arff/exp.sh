#!/bin/bash

f=$1
i=$2

echo "f = "$f
echo "i = "$i

# TODO: don't parallelize this

python 02-chop.py --fraglen=$f --seed=$i < $OUT_FOLDER/res.fasta > $OUT_FOLDER/res.fasta.$f.$i.chop
mafft --nomemsave --alga --parttree --retree 2 --partsize 1000 --thread 4 --inputorder $OUT_FOLDER/res.fasta.$f.$i.chop > $OUT_FOLDER/res.$f.$i.omega

python 03-clean.py < $OUT_FOLDER/res.$f.$i.omega > $OUT_FOLDER/res.$f.$i.clean
python 04-csv.py < $OUT_FOLDER/res.$f.$i.clean > $OUT_FOLDER/res.$f.$i.csv

java -Xmx6000M weka.core.converters.CSVLoader -B `wc -l $OUT_FOLDER_WIN/res.$f.$i.csv` $OUT_FOLDER/res.$f.$i.csv > $OUT_FOLDER/res.$f.$i.arff

rm $OUT_FOLDER/res.fasta.$f.$i.chop $OUT_FOLDER/res.$f.$i.omega $OUT_FOLDER/res.$f.$i.clean
