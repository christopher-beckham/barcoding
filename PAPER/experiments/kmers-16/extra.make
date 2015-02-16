.PHONY : R f-measure parse-f-measure summarise-arff tally-classes

R:
	python $(EXP_SHARED)/tally-classes.py < output/res50k.family.seq150.k11.arff > R/family-dist.csv
	python $(EXP_SHARED)/tally-classes.py < output/res50k.genus.seq150.k11.arff > R/genus-dist.csv
	python $(EXP_SHARED)/tally-classes.py < output/ibol.species.seq150.k11.arff > R/species-dist.csv
	RScript create-distn.R

f-measure:
	# best arff files for random forest for 450 and 600+ bp
	for filename in ibol.species.seq450.k15.arff \
	res50k.family.seq450.k15.arff \
	res50k.family.seq600.k15.arff \
	res50k.genus.seq450.k16.arff \
	res50k.genus.seq600.k15.arff; do \
		echo $$filename; \
		java -Xmx16g weka.classifiers.trees.RandomForest -I 30 -K 0 -S 1 -num-slots 4 -c last -t output/$$filename -x 3 -o -v > f-measure/$$filename.rf.result; \
	done; \
	# best arff files for naive bayes for 450 and 600+ bp
	for filename in ibol.species.seq450.k16.arff res50k.family.seq450.k16.arff res50k.family.seq600.k14.arff res50k.genus.seq450.k16.arff res50k.genus.seq600.k16.arff; do \
		echo $$filename; \
		java -Xmx16g weka.classifiers.meta.FilteredClassifier -F "weka.filters.unsupervised.attribute.BarcodingNumericToBinary -R 6" -W weka.classifiers.bayes.NaiveBayes -c last -t output/$$filename -x 3 -o -v > f-measure/$$filename.nb.result; \
	done; \

parse-f-measure:
	for filename in `find f-measure/*.result`; do \
		echo $$filename; \
		python $(EXP_SHARED)/parse-fmeasures.py < $$filename > $$filename.fmeasure; \
	done; \

summarise-arff:
	python $(EXP_SHARED)/summarise-arffs.py "output/*.arff"

tally-classes:
	for filename in `cd output; find res50k.*.k11.arff; find ibol.*.k11.arff`; do \
		echo $$filename; \
		python $(EXP_SHARED)/tally-classes.py < output/$$filename > tally-classes/$$filename.txt; \
	done; \
	RScript create-distn.R