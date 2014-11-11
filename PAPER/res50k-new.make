.PHONY : all premake json arff rf-cv rf-model rf-test nb-cv nb-model nb-test clean fullclean

###########
# GLOBALS #
###########

NUM_FOLDS = 2
TMP_OUTPUT = /cygdrive/e/tmp
SAMPLE_SIZE = 40000

SEED_MIN = 1
SEED_MAX = 1

TRAIN_FOLD = 1
TEST_FOLD = 2

premake:
	$(MAKE) -C $(EXP_SHARED) -f res50k.make
	$(MAKE) -C $(EXP_SHARED) -f ibol-phase5.make

json: premake
	for rank in family genus; do \
		python $(EXP_SHARED)/filter-json.py --maxclass=c20 --taxlevel=$$rank --minlen=300 --substr < $(OUT_FOLDER)/res50k.json.pre > output/res50k.$$rank.json; \
	done; \
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/chop-json.py --fraglen=300 --maxfrags=5 --seed={} < output/res50k.family.json > output/res50k.family.s{}.json'
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/chop-json.py --fraglen=300 --maxfrags=5 --seed={} < output/res50k.genus.json > output/res50k.genus.s{}.json'
	
	python $(EXP_SHARED)/filter-json.py --maxclass=c20 --taxlevel=species --minlen=300 --substr < $(OUT_FOLDER)/iBOL_phase_5.00_COI.json.pre > output/ibol.json
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/chop-json.py --fraglen=300 --maxfrags=5 --seed={} < output/ibol.json > output/ibol.s{}.json'
	
arff:
	# Write res50k.family.s1.big.456.arff, res50k.genus.s1.big.456.arff
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/json2arff.py --kmer=4,6 --taxlevel=family --outtrain=$(TMP_OUTPUT)/res50k.family.s{}.big.456.arff --intrain=output/res50k.family.s{}.json'
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/json2arff.py --kmer=4,6 --taxlevel=genus --outtrain=$(TMP_OUTPUT)/res50k.genus.s{}.big.456.arff --intrain=output/res50k.genus.s{}.json'
	# Write res50k.family.s1.456.arff, res50k.family.s1.456.arff
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=1 'java -Xmx13G weka.filters.unsupervised.instance.ReservoirSample -S {} -Z $(SAMPLE_SIZE) < $(TMP_OUTPUT)/res50k.family.s{}.big.456.arff > $(TMP_OUTPUT)/res50k.family.s{}.456.arff'
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=1 'java -Xmx13G weka.filters.unsupervised.instance.ReservoirSample -S {} -Z $(SAMPLE_SIZE) < $(TMP_OUTPUT)/res50k.genus.s{}.big.456.arff > $(TMP_OUTPUT)/res50k.genus.s{}.456.arff'
	# Write res50k.family.s1.456.train.arff, res50k.family.s1.456.test.arff
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=1 'java -Xmx13G weka.filters.supervised.instance.StratifiedRemoveFolds -c last -S {} -N 2 -F $(TRAIN_FOLD) < $(TMP_OUTPUT)/res50k.family.s{}.456.arff > output/res50k.family.s{}.456.train.arff'
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=1 'java -Xmx13G weka.filters.supervised.instance.StratifiedRemoveFolds -c last -S {} -N 2 -F $(TEST_FOLD) < $(TMP_OUTPUT)/res50k.family.s{}.456.arff > output/res50k.family.s{}.456.test.arff'
	# Write res50k.genus.s1.456.train.arff, res50k.genus.s1.456.test.arff
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=1 'java -Xmx13G weka.filters.supervised.instance.StratifiedRemoveFolds -c last -S {} -N 2 -F $(TRAIN_FOLD) < $(TMP_OUTPUT)/res50k.genus.s{}.456.arff > output/res50k.genus.s{}.456.train.arff'
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=1 'java -Xmx13G weka.filters.supervised.instance.StratifiedRemoveFolds -c last -S {} -N 2 -F $(TEST_FOLD) < $(TMP_OUTPUT)/res50k.genus.s{}.456.arff > output/res50k.genus.s{}.456.test.arff'
	# Write ibol.s1.big.456.arff
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/json2arff.py --kmer=4,6 --taxlevel=species --outtrain=$(TMP_OUTPUT)/ibol.s{}.big.456.arff --intrain=output/ibol.s{}.json'
	# Write ibol.s1.456.arff
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=1 'java -Xmx13G weka.filters.unsupervised.instance.ReservoirSample -S {} -Z $(SAMPLE_SIZE) < $(TMP_OUTPUT)/ibol.s{}.big.456.arff > $(TMP_OUTPUT)/ibol.s{}.456.arff'
	# Write ibol.s1.456.train.arff, ibol.s1.456.test.arff
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=1 'java -Xmx13G weka.filters.supervised.instance.StratifiedRemoveFolds -c last -S {} -N 2 -F $(TRAIN_FOLD) < $(TMP_OUTPUT)/ibol.s{}.456.arff > output/ibol.s1.456.train.arff'
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=1 'java -Xmx13G weka.filters.supervised.instance.StratifiedRemoveFolds -c last -S {} -N 2 -F $(TEST_FOLD) < $(TMP_OUTPUT)/ibol.s{}.456.arff > output/ibol.s1.456.test.arff'

rf-all: rf-cv rf-model rf-test
	echo "Done all for RF!"
	
rf-time: rf-model rf-test
	echo "Done time for RF!"
	
nb-all: nb-cv nb-model nb-test
	echo "Done all for NB!"
	
nb-time: nb-model nb-test
	echo "Done time for NB!"
	
doall: rf-cv rf-model rf-test nb-cv nb-model nb-test
	echo "done!"

testing:
	python $(EXP_SHARED)/json2arff.py --kmer=3,6 --taxlevel=family --outtrain=$(TMP_OUTPUT)/family.testing.big.arff --intrain=output/res50k.family.s1.json --freq
	java -Xmx13G weka.filters.unsupervised.instance.ReservoirSample -S 1 -Z $(SAMPLE_SIZE) < $(TMP_OUTPUT)/family.testing.big.arff > $(TMP_OUTPUT)/family.testing.arff
	java -Xmx13G weka.filters.supervised.instance.StratifiedRemoveFolds -c last -S 1 -N 2 -F $(TRAIN_FOLD) < $(TMP_OUTPUT)/family.testing.arff > output/family.testing.train.arff
	#rm $(TMP_OUTPUT)/family.testing.big.arff $(TMP_OUTPUT)/family.testing.arff
	

CV_PARAMS = -c last -x $(NUM_FOLDS) -v -o
TRAIN_PARAMS = -c last -no-cv -v
NUM_TREES = 30
GRID_PREFIX = weka.Run weka.classifiers.meta.GridSearch
GRID_POSTFIX = -E ACC -y-property classifier.search.numToSelect -y-min 0.0 -y-max 8.0 -y-step 1.0 -y-base 2.0 -y-expression 5000/pow\(BASE,I\) -filter weka.filters.AllFilter -x-property filter -x-min 0.0 -x-max 1.0 -x-step 1.0 -x-base 1.0 -x-expression I -sample-size 100.0 -traversal COLUMN-WISE -log-file /dev/null -num-slots 4 -S 1 -W weka.classifiers.meta.AttributeSelectedClassifier -- -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N -1" -W

##################
# RANDOM FORESTS #
##################

RF_POSTFIX = weka.classifiers.trees.RandomForest -- -I $(NUM_TREES) -K 0 -S 1 -num-slots 1

rf-cv:
	for rank in family genus; do \
		java -Xmx14G $(GRID_PREFIX) -t output/res50k.$$rank.s1.456.arff $(CV_PARAMS) $(GRID_POSTFIX) $(RF_POSTFIX) > results2/res50k.$$rank.rf.s1.result; \
	done	
	java -Xmx14G $(GRID_PREFIX) -t output/ibol.s1.456.arff $(CV_PARAMS) $(GRID_POSTFIX) $(RF_POSTFIX) > results2/ibol.rf.s1.result
	
rf-model:
	for rank in family genus; do \
		java -Xmx14G $(GRID_PREFIX) -t output/res50k.$$rank.s1.456.arff $(TRAIN_PARAMS) -d output/res50k.$$rank.rf.s1.456.model $(GRID_POSTFIX) $(RF_POSTFIX) > results2/res50k.$$rank.rf.s1.train; \
	done
	java -Xmx14G $(GRID_PREFIX) -t output/ibol.s1.456.arff $(TRAIN_PARAMS) -d output/ibol.rf.s1.456.model $(GRID_POSTFIX) $(RF_POSTFIX) > results2/ibol.rf.s1.train
	
rf-test:
	for rank in family genus; do \
		echo > results/res50k.$$rank.rf.s1.testing.time; \
		for i in {1..5}; do \
			{ time java -Xmx13G $(RF) -no-predictions -l output/rf.$$rank.model -T output/res50k.$$rank.s1.arff > /dev/null; } 2>> results/res50k.$$rank.rf.s1.testing.time; \
		done; \
	done
	
###############
# NAIVE BAYES #
###############

NB_POSTFIX = weka.classifiers.bayes.NaiveBayes

nb-cv:
	for rank in family genus; do \
		java -Xmx14G $(GRID_PREFIX) -t output/res50k.$$rank.s1.456.arff $(CV_PARAMS) $(GRID_POSTFIX) $(NB_POSTFIX) > results2/res50k.$$rank.nb.s1.result; \
	done
	java -Xmx14G $(GRID_PREFIX) -t output/ibol.s1.456.arff $(CV_PARAMS) $(GRID_POSTFIX) $(NB_POSTFIX) > results2/ibol.nb.s1.result
	
nb-model:
	for rank in family genus; do \
		java -Xmx14G $(GRID_PREFIX) -t output/res50k.$$rank.s1.456.arff $(TRAIN_PARAMS) -d output/res50k.$$rank.nb.s1.456.model $(GRID_POSTFIX) $(NB_POSTFIX) > results2/res50k.$$rank.nb.s1.train; \
	done
	java -Xmx14G $(GRID_PREFIX) -t output/ibol.s1.456.arff $(TRAIN_PARAMS) -d output/ibol.nb.s1.456.model $(GRID_POSTFIX) $(NB_POSTFIX) > results2/ibol.nb.s1.train

nb-test:
	for rank in family genus; do \
		echo > results/res50k.$$rank.nb.s1.testing.time; \
		for i in {1..5}; do \
			{ time java -Xmx13G $(NB) -no-predictions -l output/nb.$$rank.model -T output/res50k.$$rank.s1.arff > /dev/null; } 2>> results/res50k.$$rank.nb.s1.testing.time; \
		done; \
	done