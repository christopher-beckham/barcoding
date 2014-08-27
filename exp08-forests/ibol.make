.PHONY : all premake json arff clean fullclean test

SEED_MIN = 1
SEED_MAX = 5

premake:
	$(MAKE) -C $(EXP_SHARED) -f ibol-phase5.make

json: premake
	seq $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/chop-json-fasta.py --fraglen=300 --seed={} < $(OUT_FOLDER)/iBOL_phase_5.00_COI.json.pre > output/ibol.s{}.json'
	
arff:
	seq $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=2 'python $(EXP_SHARED)/json2arff.py --kmer="3,5" --taxlevel="species" --outfile=output/ibol.s{}.arff --outlist=null --infile=output/ibol.s{}.json --maxclass="c20"'

test:
	for i in {$(SEED_MIN)..$(SEED_MAX)}; do \
		for j in {1..5}; do \
			{ time java -server -Xmx4000M weka.classifiers.trees.J48 -t weather.nominal.arff >  } 2> ibol.s$$i.c$$j.time; \
		done; \
	done

##################
# RANDOM FORESTS #
##################	
	
rf-cv:
	for i in {$(SEED_MIN)..$(SEED_MAX)}; do \
		for j in {1..5}; do \
			java -server -Xmx6000M weka.classifiers.meta.FilteredClassifier -F "weka.filters.unsupervised.attribute.Discretize -B 10 -M -1.0 -R first-last" -W weka.classifiers.meta.AttributeSelectedClassifier -t output/ibol.s$$i.arff -x 2 -v -o -no-predictions -c last -s $$j -- -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N -1" -W weka.classifiers.trees.RandomForest -- -I 10 -K 0 -S 1 -num-slots 4 > results/ibol.s$$i.c$$j.result; \
		done; \
	done

rf-model:
	touch results/ibol.s1.training.time
	for i in {1..5}; do \
		{ time java -server -Xmx6000M weka.classifiers.meta.FilteredClassifier -F "weka.filters.unsupervised.attribute.Discretize -B 10 -M -1.0 -R first-last" -W weka.classifiers.meta.AttributeSelectedClassifier -t output/ibol.s1.arff -no-predictions -c last -d output/rf.model -- -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N -1" -W weka.classifiers.trees.RandomForest -- -I 10 -K 0 -S 1 -num-slots 4 > /dev/null; } 2>> results/ibol.s1.training.time; \
	done
	
rf-test:
	touch results/ibol.s1.testing.time
	for i in {1..5}; do \
		{ time java -Xmx6000M weka.classifiers.meta.FilteredClassifier -l output/rf.model -T output/ibol.s1.arff ; } 2>> results/ibol.s1.testing.time; \
	done
	
clean:
	rm output/*.json

fullclean: clean
	rm $(OUT_FOLDER)/iBOL_phase_5.00_COI.json