training: res.csv

res.csv: res.clean
	python 04-csv.py < output/res.clean > output/res.csv

res.clean: res.omega
	#python aln-consensus.py < res.aln > res.clean
	python 03-clean.py output/res.omega > output/res.clean

res.omega: res.fasta
	# clustalw2 -align -type=dna -infile=res.fasta -outfile=res.aln
	$CLUSTALO --infile=output/res.fasta --outfile=output/res.omega --infmt=fasta --seqtype=dna --threads=4 --verbose

res.fasta:
	python 01-query.py $EXP01_NUCLIMIT > output/res.fasta
	
clean:
	rm output/*.*