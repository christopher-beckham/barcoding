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
	$(MAKE) -C $(EXP_SHARED) -f res50k.make

json: premake
	for rank in family genus; do \
		python $(EXP_SHARED)/filter-json.py --maxclass=c20 --taxlevel=$$rank --minlen=300 < $(OUT_FOLDER)/res50k.json.pre > output/res50k.$$rank.json; \
	done; \
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/chop-json.py --fraglen=300 --maxfrags=5 --seed={} < output/res50k.family.json > output/res50k.family.s{}.json
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/chop-json.py --fraglen=300 --maxfrags=5 --seed={} < output/res50k.genus.json > output/res50k.genus.s{}.json
	
arff:
	#$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/json2arff.py --kmer=6,6 --taxlevel=family --outtrain=$(TMP_OUTPUT)/res50k.family.s{}.big.arff --intrain=output/res50k.family.s{}.json'
	#$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/json2arff.py --kmer=6,6 --taxlevel=genus --outtrain=$(TMP_OUTPUT)/res50k.genus.s{}.big.arff --intrain=output/res50k.genus.s{}.json'
	
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=1 'java -Xmx7000M weka.filters.unsupervised.instance.ReservoirSample -S {} -Z $(SAMPLE_SIZE) < $(TMP_OUTPUT)/res50k.family.s{}.big.arff > output/res50k.family.s{}.arff'
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=1 'java -Xmx7000M weka.filters.unsupervised.instance.ReservoirSample -S {} -Z $(SAMPLE_SIZE) < $(TMP_OUTPUT)/res50k.genus.s{}.big.arff > output/res50k.genus.s{}.arff'

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
	
custom: rf-model rf-test
	
##################
# RANDOM FORESTS #
##################

NUM_TREES = 30
RF_PREFIX = weka.classifiers.trees.RandomForest -I $(NUM_TREES) -K 0 -S 1 -num-slots 4
RF = weka.classifiers.trees.RandomForest

###################
# INFO GAIN GRAPH #
###################

info-gain:
	for num in 1000 500 250; do \
		if [ -e output/nb.ig$$num.model ]; then \
			rm output/nb.ig$$num.model; \
		fi; \
		java -Xmx7000M weka.classifiers.meta.AttributeSelectedClassifier -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0 -N $$num" -W weka.classifiers.bayes.NaiveBayes -t output/res50k.family.s1.arff -no-predictions -c last -d output/nb.ig$$num.model -x $(NUM_FOLDS) -o -v -- -D > results/res50k.family.nb.s1.ig$$num.result; \
		echo > results/res50k.family.nb.s1.ig$$num.time; \
		for i in {1..5}; do \
			{ time java -Xmx7000M weka.classifiers.meta.AttributeSelectedClassifier -no-predictions -l output/nb.ig$$num.model -T output/res50k.family.s1.arff > /dev/null; } 2>> results/res50k.family.nb.s1.ig$$num.time; \
		done; \
	done

########
# MAIN #
########

deleteme:
	for rank in genus; do \
		for i in {3..$(SEED_MAX)}; do \
			java -Xmx7000M $(RF_PREFIX) -t output/res50k.$$rank.s$$i.arff -no-predictions -c last -x $(NUM_FOLDS) -v -o $(RF_POSTFIX) > results/res50k.$$rank.rf.s$$i.result; \
		done; \
	done
	
rf-cv:
	for rank in family genus; do \
		for i in {$(SEED_MIN)..$(SEED_MAX)}; do \
			java -Xmx7000M $(RF_PREFIX) -t output/res50k.$$rank.s$$i.arff -no-predictions -c last -x $(NUM_FOLDS) -v -o $(RF_POSTFIX) > results/res50k.$$rank.rf.s$$i.result; \
		done; \
	done

rf-model:
	for rank in family genus; do \
		if [ -e output/rf.$$rank.model ]; then \
			rm output/rf.$$rank.model; \
		fi; \
	done; \
	for rank in family genus; do \
		echo > results/res50k.$$rank.rf.s1.training.time; \
		for i in {1..5}; do \
			echo "Progress: "$$i; \
			{ time java -Xmx7000M $(RF_PREFIX) -t output/res50k.$$rank.s1.arff -no-predictions -c last -d output/rf.$$rank.model -no-cv -o -v $(RF_POSTFIX) > /dev/null; } 2>> results/res50k.$$rank.rf.s1.training.time; \
			if [ $$i != 5 ]; then \
				rm output/rf.$$rank.model; \
			fi; \
		done; \
	done
	
rf-test:
	for rank in family genus; do \
		echo > results/res50k.$$rank.rf.s1.testing.time; \
		for i in {1..5}; do \
			{ time java -Xmx7000M $(RF) -no-predictions -l output/rf.$$rank.model -T output/res50k.$$rank.s1.arff > /dev/null; } 2>> results/res50k.$$rank.rf.s1.testing.time; \
		done; \
	done
	
###############
# NAIVE BAYES #
###############

NB_PREFIX = weka.classifiers.bayes.NaiveBayes
NB = weka.classifiers.bayes.NaiveBayes

nb-cv:
	for rank in family genus; do \
		for i in {$(SEED_MIN)..$(SEED_MAX)}; do \
			java -Xmx7000M $(NB_PREFIX) -t output/res50k.$$rank.s$$i.arff -no-predictions -c last -x $(NUM_FOLDS) -v -o $(NB_POSTFIX) > results/res50k.$$rank.nb.s$$i.result; \
		done; \
	done
	
nb-model:
	for rank in family genus; do \
		if [ -e output/nb.$$rank.model ]; then \
			rm output/nb.$$rank.model; \
		fi; \
	done; \
	for rank in family genus; do \
		echo > results/res50k.$$rank.nb.s1.training.time; \
		for i in {1..5}; do \
			echo "Progress: "$$i; \
			{ time java -Xmx7000M $(NB_PREFIX) -t output/res50k.$$rank.s1.arff -no-predictions -c last -d output/nb.$$rank.model -no-cv -o -v $(NB_POSTFIX) > /dev/null; } 2>> results/res50k.$$rank.nb.s1.training.time; \
			if [ $$i != 5 ]; then \
				rm output/nb.$$rank.model; \
			fi; \
		done; \
	done

nb-test:
	for rank in family genus; do \
		echo > results/res50k.$$rank.nb.s1.testing.time; \
		for i in {1..5}; do \
			{ time java -Xmx7000M $(NB) -no-predictions -l output/nb.$$rank.model -T output/res50k.$$rank.s1.arff > /dev/null; } 2>> results/res50k.$$rank.nb.s1.testing.time; \
		done; \
	done

###########
# CLEANUP #
###########
	
clean:
	rm output/*.*
	rm results/*.*

fullclean: clean
	rm $(OUT_FOLDER)/res50k.json
