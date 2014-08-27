.PHONY : all premake json arff clean fullclean

RESULTS = results/ibol

premake:
	$(MAKE) -C $(EXP_SHARED) -f ibol-phase5.make

json: premake
	for seed in 1 2 3 4 5 ; do \
		python $(EXP_SHARED)/chop-json-fasta.py --seed=$$seed --fraglen=300 < $(OUT_FOLDER)/iBOL_phase_5.00_COI.json.pre > output/ibol.s$$seed.json; \
	done
	
arff:
	# todo: parallelise this?
	for seed in 1 2 3 4 5 ; do \
		python $(EXP_SHARED)/json2arff.py --kmer="3,5" --taxlevel="species" --outfile=output/ibol.s$$seed.arff --outlist=null --infile=output/ibol.s$$seed.json --maxclass="c20"; \
	done

#output/ibol.c40.f1.arff: premake
	# For genbank.make, --maxclass was set to "c20". For this, we set it to "c40" then take one stratified fold and use that as the training set, which should
	# reduce any class with 40 values down to half (20).
	#python 01-csv-new.py --kmer="3,5" --taxlevel="species" --outfile=output/ibol.c40.arff --outlist=null --infile=$(OUT_FOLDER)/iBOL_phase_5.00_COI.json --maxclass="c40"
	#java -Xmx6000M weka.filters.supervised.instance.StratifiedRemoveFolds -N 2 -F 1 -S 1 -c last -i output/ibol.c40.arff -o output/ibol.c40.f1.arff
	
#output/ibol.c30.f1.arff: premake
	# See what sort of accuracy we get when we set the --maxclass to "c30" instead.
	#python 01-csv-new.py --kmer="3,5" --taxlevel="species" --outfile=output/ibol.c30.arff --outlist=null --infile=$(OUT_FOLDER)/iBOL_phase_5.00_COI.json --maxclass="c5"
	#java -Xmx6000M weka.filters.supervised.instance.StratifiedRemoveFolds -N 2 -F 1 -S 1 -c last -i output/ibol.c30.arff -o output/ibol.c30.f1.arff
	# m647 -- nb
	#java -Xmx6000M weka.classifiers.meta.AttributeSelectedClassifier -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N -1" -W weka.classifiers.bayes.NaiveBayes -t output/ibol.c30.f1.arff -split-percentage 50 -- -D > deleteme.txt

clean:
	rm output/*.json

fullclean: clean
	rm $(OUT_FOLDER)/iBOL_phase_5.00_COI.json