.PHONY : all premake json arff rf-cv rf-model rf-test nb-cv nb-model nb-test clean fullclean

SEED_MIN = 1
SEED_MAX = 5

premake:
	$(MAKE) -C $(EXP_SHARED) -f res50k.make

json: premake
	seq $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/chop-json-fasta.py --fraglen=300 --seed={} < $(OUT_FOLDER)/res50k.json.pre > output/res50k.s{}.json'
	
arff:
	for rank in family genus; do \
		seq $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=2 'python $(EXP_SHARED)/json2arff.py --kmer="3,5" --taxlevel=$$rank --outfile=output/res50k.$$rank.s{}.arff --outlist=null --infile=output/res50k.s{}.json --maxclass="c20"'; \
	done

timeall: rf-test nb-test
	echo "done!"
	
RESULTS = results/res50k
	
##################
# RANDOM FORESTS #
##################	

RF_PREFIX = weka.classifiers.trees.RandomForest -I 10 -K 0 -S 1 -num-slots 4
RF = weka.classifiers.trees.RandomForest

rf-cv:

	for rank in family genus; do \
		for i in {$(SEED_MIN)..$(SEED_MAX)}; do \
			java -server -Xmx6000M $(RF_PREFIX) -t output/res50k.$$rank.s$$i.arff -no-predictions -c last -x 2 -v -o $(RF_POSTFIX) > $(RESULTS)/res50k.$$rank.rf.s$$i.result; \
		done; \
	done

rf-model:
	for rank in family genus; do \
		if [ -e output/rf.$$rank.model ]; then \
			rm output/rf.$$rank.model; \
		fi; \
	done; \
	for rank in family genus; do \
		echo > $(RESULTS)/res50k.$$rank.rf.s1.training.time; \
		for i in {1..5}; do \
			echo "Progress: "$$i; \
			{ time java -Xmx6000M $(RF_PREFIX) -t output/res50k.$$rank.s1.arff -no-predictions -c last -d output/rf.$$rank.model -no-cv -o -v $(RF_POSTFIX) > /dev/null; } 2>> $(RESULTS)/res50k.$$rank.rf.s1.training.time; \
			if [ $$i != 5 ]; then \
				rm output/rf.$$rank.model; \
			fi; \
		done; \
	done
	
rf-test:
	for rank in family genus; do \
		echo > $(RESULTS)/res50k.$$rank.rf.s1.testing.time; \
		for i in {1..5}; do \
			{ time java -Xmx6000M $(RF) -no-predictions -l output/rf.$$rank.model -T output/res50k.$$rank.s1.arff > /dev/null; } 2>> $(RESULTS)/res50k.$$rank.rf.s1.testing.time; \
		done; \
	done
	
###############
# NAIVE BAYES #
###############

#NB_PREFIX = weka.classifiers.meta.FilteredClassifier -F "weka.filters.unsupervised.attribute.Discretize -F -B 10 -M -1.0 -R first-last" -W weka.classifiers.bayes.NaiveBayes
NB_PREFIX = weka.classifiers.bayes.NaiveBayes -D
NB = weka.classifiers.bayes.NaiveBayes

nb-cv:
	for rank in family genus; do \
		for i in {$(SEED_MIN)..$(SEED_MAX)}; do \
			java -server -Xmx6000M $(NB_PREFIX) -t output/res50k.$$rank.s$$i.arff -no-predictions -c last -x 2 -v -o $(NB_POSTFIX) > $(RESULTS)/res50k.$$rank.nb.s$$i.result; \
		done; \
	done
	
nb-model:
	for rank in family genus; do \
		if [ -e output/nb.$$rank.model ]; then \
			rm output/nb.$$rank.model; \
		fi; \
	done; \
	for rank in family genus; do \
		echo > $(RESULTS)/res50k.$$rank.nb.s1.training.time; \
		for i in {1..5}; do \
			echo "Progress: "$$i; \
			{ time java -Xmx6000M $(NB_PREFIX) -t output/res50k.$$rank.s1.arff -no-predictions -c last -d output/nb.$$rank.model -no-cv -o -v $(NB_POSTFIX) > /dev/null; } 2>> $(RESULTS)/res50k.$$rank.nb.s1.training.time; \
			if [ $$i != 5 ]; then \
				rm output/nb.$$rank.model; \
			fi; \
		done; \
	done

nb-test:
	for rank in family genus; do \
		echo > $(RESULTS)/res50k.$$rank.nb.s1.testing.time; \
		for i in {1..5}; do \
			{ time java -Xmx6000M $(NB) -no-predictions -l output/nb.$$rank.model -T output/res50k.$$rank.s1.arff > /dev/null; } 2>> $(RESULTS)/res50k.$$rank.nb.s1.testing.time; \
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