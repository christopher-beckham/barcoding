.PHONY : R f-measure

R:
	python $(EXP_SHARED)/tally-classes.py < output/res50k.family.seq150.k11.arff > R/family-dist.csv
	python $(EXP_SHARED)/tally-classes.py < output/res50k.genus.seq150.k11.arff > R/genus-dist.csv
	python $(EXP_SHARED)/tally-classes.py < output/ibol.species.seq150.k11.arff > R/species-dist.csv
	RScript create-distn.R

f-measure:
	# best genus600 = RF, best family600 = RF, best species600 = RF
	for filename in res50k.genus.seq600.k15.arff res50k.family.seq600.k15.arff ibol.species.seq600.k15.arff; do \
		echo $$filename; \
		java -Xmx16g weka.classifiers.trees.RandomForest -I 10 -K 0 -S 1 -num-slots 4 -t output/$$filename -x 3 -o -v > f-measure/$$filename.result; \
	done; \
	# best genus450 = NB, best family450 = NB, best species450 = NB
	for filename in res50k.genus.seq450.k15.arff res50k.family.seq450.k16.arff ibol.species.seq450.k14.arff; do \
		echo $$filename; \
		java -Xmx16g weka.classifiers.meta.FilteredClassifier -F "weka.filters.unsupervised.attribute.Discretize -F -B 10 -M -1.0 -R first-last" -W weka.classifiers.bayes.NaiveBayes -t output/$$filename -x 3 -o -v > f-measure/$$filename.result; \
	done; \