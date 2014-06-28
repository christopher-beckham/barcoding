# -------------------------------------------------
# http://www.gnu.org/software/make/manual/make.html
# -------------------------------------------------

# "If you write a rule whose recipe will not create the target file,
# the recipe will be executed every time the target comes up for remaking".
# -- So if we don't phony "train", it will think it's a file that doesn't exist,
#    and will end up trying to "make" it.
.PHONY : train clean fullclean

train: output/res.csv
	java -Xmx6000M weka.classifiers.bayes.NaiveBayes -t output/res.csv -c last -x 3 > output/res.csv.naivebayes

output/res.csv: output/res.clean
	python 04-csv.py < output/res.clean > output/res.csv
	
#train_100: res.100.clean
#	python 04-csv.py < output/res.100.clean > output/res.100.csv

#res.100.clean: res.omega
#	echo "not implemented yet"

output/res.clean: output/res.omega
	#python aln-consensus.py < res.aln > res.clean
	python 03-clean.py < output/res.omega > output/res.clean

output/res.omega: output/res.fasta
	# clustalw2 -align -type=dna -infile=res.fasta -outfile=res.aln
	$(CLUSTALO) --infile=output/res.fasta --outfile=output/res.omega --infmt=fasta --seqtype=dna --threads=4 --verbose --force

output/res.fasta:
	python 01-query.py --limit $(EXP01_NUCLIMIT) > output/res.fasta
	
clean:
	# ignore error for now, it works
	find output | grep -v "output/res.fasta" | xargs rm
	
fullclean:
	rm output/*.*