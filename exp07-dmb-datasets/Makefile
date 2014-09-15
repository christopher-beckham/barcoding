.PHONY: birds cyp

SEED_MIN = 1
SEED_MAX = 5

# MAC OS X USERS - you may have to change seq to gseq
SEQ = seq

cyp:
	python fasta2json.py --infile=data/cypraeidae/CypAll.fasta > output/CypAll.json.pre
	#python $EXP_SHARED/json2arff.py --infile=output/CypAll.json --outfile=output/CypAll.arff --kmerrange=3,5 --maxclass=m100000
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/chop-json-fasta.py --fraglen=300 --seed={} < output/CypAll.json.pre > output/CypAll.s{}.json'
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=2 'python $(EXP_SHARED)/json2arff.py --kmer="3,5" --taxlevel="species" --outfile=output/CypAll.s{}.arff --infile=output/CypAll.s{}.json --maxclass="m100000"'