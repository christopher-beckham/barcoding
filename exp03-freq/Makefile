.PHONY: shared train-genus

shared:
	$(MAKE) -C $(EXP_SHARED) -f res50k.make

train-genus: shared
	python 01-csv-new.py --kmer="3,5" --taxlevel="genus" --outfile=$(OUT_FOLDER)/res50k.arff --outlist=null --infile=$(OUT_FOLDER)/res50k.json --maxclass=300
