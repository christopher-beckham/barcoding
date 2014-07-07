#!/bin/bash

for f in 100 200 300 400 500; do
	echo "f = "$f
	for i in {0..4}; do
		echo "i = "$i
		python 02-chop.py --fraglen=$f --seed=$i < output/res.fasta > output/res.fasta.$i.chop
		mafft --thread 4 --auto output/res.fasta.$i.chop > output/res.$i.omega
		python 03-clean.py < output/res.$i.omega > output/res.$i.clean
		python 04-csv.py < output/res.$i.clean > output/res.$f.$i.csv
		
		rm output/res.fasta.$i.chop output/res.$i.omega output/res.$i.clean
	done
done