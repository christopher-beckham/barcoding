.PHONY : all premake json arff rf-cv rf-model rf-test nb-cv nb-model nb-test clean fullclean

###########
# GLOBALS #
###########

NUM_FOLDS = 3
TMP_OUTPUT = /cygdrive/e/tmp
SAMPLE_SIZE = 30000

SEED_MIN = 1
SEED_MAX = 5

premake:
	$(MAKE) -C $(EXP_SHARED) -f ibol-phase5.make

json: premake
	python $(EXP_SHARED)/filter-json.py --maxclass=c20 --taxlevel=species --minlen=300 < $(OUT_FOLDER)/iBOL_phase_5.00_COI.json.pre > output/ibol.json
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/chop-json.py --fraglen=300 --maxfrags=5 --seed={} < output/ibol.json > output/ibol.s{}.json'
	
arff:
	#$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/json2arff.py --kmer=6,6 --taxlevel=species --outtrain=$(TMP_OUTPUT)/ibol.s{}.big.arff --intrain=output/ibol.s{}.json'
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=1 'java -Xmx7000M weka.filters.unsupervised.instance.ReservoirSample -S {} -Z $(SAMPLE_SIZE) < $(TMP_OUTPUT)/ibol.s{}.big.arff > output/ibol.s{}.arff'

doall: rf-cv rf-model rf-test nb-cv nb-model nb-test
	echo "done!"
	
custom: nb-cv nb-model nb-test
	
##################
# RANDOM FORESTS #
##################

NUM_TREES = 10
RF_PREFIX = weka.classifiers.trees.RandomForest -I $(NUM_TREES) -K 0 -S 1 -num-slots 4
RF = weka.classifiers.trees.RandomForest

rf-cv:
	for i in {$(SEED_MIN)..$(SEED_MAX)}; do \
		java -Xmx7000M $(RF_PREFIX) -t output/ibol.s$$i.arff -no-predictions -c last -x $(NUM_FOLDS) -v -o $(RF_POSTFIX) > results/ibol.rf.s$$i.result; \
	done

rf-model:
	echo > results/ibol.rf.s1.training.time
	for i in {1..5}; do \
		echo "Progress: "$$i; \
		{ time java -Xmx7000M $(RF_PREFIX) -t output/ibol.s1.arff -no-predictions -c last -d output/rf.model -no-cv -o -v $(RF_POSTFIX) > /dev/null; } 2>> results/ibol.rf.s1.training.time; \
		if [ $$i != 5 ]; then \
			rm output/rf.model; \
		fi; \
	done
	
rf-test:
	echo > results/ibol.rf.s1.testing.time
	for i in {1..5}; do \
		{ time java -Xmx7000M $(RF) -no-predictions -l output/rf.model -T output/ibol.s1.arff > /dev/null; } 2>> results/ibol.rf.s1.testing.time; \
	done
	
###############
# NAIVE BAYES #
###############

NB_PREFIX = weka.classifiers.bayes.NaiveBayes
NB = weka.classifiers.bayes.NaiveBayes

nb-cv:
	for i in {$(SEED_MIN)..$(SEED_MAX)}; do \
		java -Xmx7000M $(NB_PREFIX) -t output/ibol.s$$i.arff -no-predictions -c last -x $(NUM_FOLDS) -v -o $(NB_POSTFIX) > results/ibol.nb.s$$i.result; \
	done
	
nb-model:
	echo > results/ibol.nb.s1.training.time
	for i in {1..5}; do \
		echo "Progress: "$$i; \
		{ time java -Xmx7000M $(NB_PREFIX) -t output/ibol.s1.arff -no-predictions -c last -d output/nb.model -no-cv -o -v $(NB_POSTFIX) > /dev/null; } 2>> results/ibol.nb.s1.training.time; \
		if [ $$i != 5 ]; then \
			rm output/nb.model; \
		fi; \
	done

nb-test:
	echo > results/ibol.nb.s1.testing.time
	for i in {1..5}; do \
		{ time java -Xmx7000M $(NB) -no-predictions -l output/nb.model -T output/ibol.s1.arff > /dev/null; } 2>> results/ibol.nb.s1.testing.time; \
	done

###########
# CLEANUP #
###########
	
clean:
	rm output/*.*
	rm results/*.*

fullclean: clean
	rm $(OUT_FOLDER)/iBOL_phase_5.00_COI.json