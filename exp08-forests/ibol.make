.PHONY : all premake json arff rf-cv rf-model rf-test nb-cv nb-model nb-test clean fullclean

SEED_MIN = 1
SEED_MAX = 5

# MAC OS X USERS - you may have to change seq to gseq
SEQ = seq

premake:
	$(MAKE) -C $(EXP_SHARED) -f ibol-phase5.make

json: premake
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/chop-json-fasta.py --fraglen=300 --seed={} < $(OUT_FOLDER)/iBOL_phase_5.00_COI.json.pre > output/ibol.s{}.json'
	
arff:
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=2 'python $(EXP_SHARED)/json2arff.py --kmer="3,5" --taxlevel="species" --outtrain=output/ibol.s{}.arff --intrain=output/ibol.s{}.json --maxclass="c20"'

timeall: rf-cv rf-model rf-test
	echo "done!"
	
deleteme:
	python $(EXP_SHARED)/json2arff.py --kmer="3,5" --taxlevel="species" --outtrain=deleteme.arff --intrain=output/ibol.s1.json --maxclass="c20"
	
##################
# RANDOM FORESTS #
##################	

#RF_PREFIX = weka.classifiers.meta.FilteredClassifier -F "weka.filters.unsupervised.attribute.Discretize -B 10 -M -1.0 -R first-last" -W weka.classifiers.meta.AttributeSelectedClassifier 
#RF_POSTFIX = -- -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N -1" -W weka.classifiers.trees.RandomForest -- -I 10 -K 0 -S 1 -num-slots 4

RF_PREFIX = weka.classifiers.trees.RandomForest -I 10 -K 0 -S 1 -num-slots 4
RF = weka.classifiers.trees.RandomForest

rf-cv:
	for i in {$(SEED_MIN)..$(SEED_MAX)}; do \
		java -server -Xmx6000M $(RF_PREFIX) -t output/ibol.s$$i.arff -no-predictions -c last -x 2 -v -o $(RF_POSTFIX) > results/ibol.rf.s$$i.result; \
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
		{ time java -Xmx6000M $(RF) -no-predictions -l output/rf.model -T output/ibol.s1.arff > /dev/null; } 2>> results/ibol.rf.s1.testing.time; \
	done
	
###############
# NAIVE BAYES #
###############

#NB_PREFIX = weka.classifiers.meta.FilteredClassifier -F "weka.filters.unsupervised.attribute.Discretize -B 10 -M -1.0 -R first-last" -W weka.classifiers.meta.AttributeSelectedClassifier
#NB_POSTFIX = -- -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N -1" -W weka.classifiers.bayes.NaiveBayes

NB_PREFIX = weka.classifiers.meta.FilteredClassifier -F "weka.filters.unsupervised.attribute.Discretize -F -B 10 -M -1.0 -R first-last" -W weka.classifiers.bayes.NaiveBayes
NB = weka.classifiers.meta.FilteredClassifier

nb-cv:
	for i in {$(SEED_MIN)..$(SEED_MAX)}; do \
		java -server -Xmx6000M $(NB_PREFIX) -t output/ibol.s$$i.arff -no-predictions -c last -x 2 -v -o $(NB_POSTFIX) > results/ibol.nb.s$$i.result; \
	done
	
nb-model:
	echo > results/ibol.nb.s1.training.time
	for i in {1..5}; do \
		echo "Progress: "$$i; \
		{ time java -Xmx6000M $(NB_PREFIX) -t output/ibol.s1.arff -no-predictions -c last -d output/nb.model -no-cv -o -v $(NB_POSTFIX) > /dev/null; } 2>> results/ibol.nb.s1.training.time; \
		if [ $$i != 5 ]; then \
			rm output/nb.model; \
		fi; \
	done

nb-test:
	echo > results/ibol.nb.s1.testing.time
	for i in {1..5}; do \
		{ time java -Xmx6000M $(NB) -no-predictions -l output/nb.model -T output/ibol.s1.arff > /dev/null; } 2>> results/ibol.nb.s1.testing.time; \
	done

###########
# CLEANUP #
###########
	
clean:
	rm output/*.*
	rm results/*.*

fullclean: clean
	rm $(OUT_FOLDER)/iBOL_phase_5.00_COI.json