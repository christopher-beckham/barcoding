training: res.csv

res.csv: res.clean
	python csv-create.py < res.clean > res.csv

res.clean: res.omega
	#python aln-consensus.py < res.aln > res.clean
	python omega-consensus.py res.omega > res.clean

res.omega: res.fasta
	# clustalw2 -align -type=dna -infile=res.fasta -outfile=res.aln
	/cygdrive/c/clustal-omega-1.2.1/src/clustalo.exe --infile=res.fasta --outfile=res.omega --infmt=fasta --seqtype=dna --threads=4 --verbose

res.fasta:
	python query.py 3000 > res.fasta
	
clean:
	rm res.clean res.aln res.fasta