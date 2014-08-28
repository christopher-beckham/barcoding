.PHONY : all premake json arff rf-cv rf-model rf-test nb-cv nb-model nb-test clean fullclean

SEED_MIN = 1
SEED_MAX = 5

premake:
	$(MAKE) -C $(EXP_SHARED) -f ibol-phase5.make
	$(MAKE) -C $(EXP_SHARED) -f res50k.make

json: premake
	seq $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/chop-json-fasta.py --fraglen=300 --seed={} < $(OUT_FOLDER)/iBOL_phase_5.00_COI.json.pre > output/ibol.s{}.json'
	seq $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/chop-json-fasta.py --fraglen=300 --seed={} < $(OUT_FOLDER)/res50k.json.pre > output/res50k.s{}.json'
	
arff:
	seq $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=2 'python $(EXP_SHARED)/json2arff.py --kmer="3,5" --taxlevel="species" --outfile=output/ibol.s{}.arff --outlist=null --infile=output/ibol.s{}.json --maxclass="c20"'
	seq $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=2 'python $(EXP_SHARED)/json2arff.py --kmer="3,5" --taxlevel="genus" --outfile=output/res50k.s{}.arff --outlist=null --infile=output/res50k.s{}.json --maxclass="c20"'

##################
# RANDOM FORESTS #
##################	

RF_PREFIX = weka.classifiers.meta.FilteredClassifier -F "weka.filters.unsupervised.attribute.Discretize -B 10 -M -1.0 -R first-last" -W weka.classifiers.meta.AttributeSelectedClassifier 
RF_POSTFIX = -- -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N -1" -W weka.classifiers.trees.RandomForest -- -I 10 -K 0 -S 1 -num-slots 4

rf-cv:
	for i in {$(SEED_MIN)..$(SEED_MAX)}; do \
		java -server -Xmx6000M $(RF_PREFIX) -t output/ibol.s$$i.arff -x 2 -v -o -c last $(RF_POSTFIX) > results/ibol.rf.s$$i.result; \
	done

rf-model:
	echo > results/ibol.rf.s1.training.time
	for i in {1..5}; do \
		echo "Progress: "$$i; \
		{ time java -Xmx6000M $(RF_PREFIX) -t output/ibol.s1.arff -no-predictions -c last -d output/rf.model -no-cv -o -v $(RF_POSTFIX) > /dev/null; } 2>> results/ibol.rf.s1.training.time; \
		if [ $$i != 5 ]; then \
			rm output/rf.model; \
		fi; \
	done
	
rf-test:
	echo > results/ibol.rf.s1.testing.time
	for i in {1..5}; do \
		{ time java -Xmx6000M weka.classifiers.meta.FilteredClassifier -l output/rf.model -T output/ibol.s1.arff > /dev/null; } 2>> results/ibol.rf.s1.testing.time; \
	done
	
###############
# NAIVE BAYES #
###############

NB_PREFIX = weka.classifiers.meta.FilteredClassifier -F "weka.filters.unsupervised.attribute.Discretize -B 10 -M -1.0 -R first-last" -W weka.classifiers.meta.AttributeSelectedClassifier
NB_POSTFIX = -- -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N -1" -W weka.classifiers.bayes.NaiveBayes

nb-cv:
	for i in {$(SEED_MIN)..$(SEED_MAX)}; do \
		java -server -Xmx6000M $(NB_PREFIX) -t output/ibol.s$$i.arff -x 2 -v -o -no-predictions -c last $(NB_POSTFIX) > results/ibol.nb.s$$i.result; \
	done
	
nb-model:
	echo > results/ibol.nb.s1.training.time
	for i in {1..5}; do \
		echo "Progress: "$$i; \
		{ time java -Xmx6000M $(NB_PREFIX) -t output/ibol.s1.arff -c last -d output/nb.model -no-cv -o -v $(NB_POSTFIX) > /dev/null; } 2>> results/ibol.nb.s1.training.time; \
		if [ $$i != 5 ]; then \
			rm output/nb.model; \
		fi; \
	done

nb-test:
	echo > results/ibol.nb.s1.testing.time
	for i in {1..5}; do \
		{ time java -Xmx6000M weka.classifiers.meta.FilteredClassifier -l output/nb.model -T output/ibol.s1.arff > /dev/null; } 2>> results/ibol.nb.s1.testing.time; \
	done

###########
# CLEANUP #
###########
	
clean:
	rm output/*.*
	rm results/*.*

fullclean: clean
	rm $(OUT_FOLDER)/iBOL_phase_5.00_COI.json
	rm $(OUT_FOLDER)/res50k.json