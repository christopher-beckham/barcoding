.PHONY : all premake json arff rf-train rf-test rf-test-time nb-train nb-test nb-test-time rf-all rf-time nb-all nb-time

###########
# GLOBALS #
###########

TMP_TESTING = /cygdrive/e/tmp2
SAMPLE_SIZE = 40000

TRAIN_FOLD = 1
TEST_FOLD = 2

premake:
	#$(MAKE) -C $(EXP_SHARED) -f res50k.make
	#$(MAKE) -C $(EXP_SHARED) -f ibol-phase5.make
	echo "This does nothing anymore."

json:
	python $(EXP_SHARED)/split-json.py --fold=$(TEST_FOLD) < $(OUT_FOLDER)/res50k.json.clean > output-testing/res50k.json
	python $(EXP_SHARED)/split-json.py --fold=$(TEST_FOLD) < $(OUT_FOLDER)/ibol.json.clean > output-testing/ibol.json
	
	for rank in family genus; do \
		python $(EXP_SHARED)/filter-json.py --maxclass=c10 --taxlevel=$$rank --minlen=300 --substr < output-testing/res50k.json > output-testing/res50k.$$rank.json; \
	done; \
	python $(EXP_SHARED)/chop-json.py --fraglen=300 --maxfrags=5 --seed=1 < output-testing/res50k.family.json > output-testing/res50k.family.s1.json
	python $(EXP_SHARED)/chop-json.py --fraglen=300 --maxfrags=5 --seed=1 < output-testing/res50k.genus.json > output-testing/res50k.genus.s1.json
	
	python $(EXP_SHARED)/filter-json.py --maxclass=c10 --taxlevel=species --minlen=300 --substr < output-testing/ibol.json > output-testing/ibol.species.json
	python $(EXP_SHARED)/chop-json.py --fraglen=300 --maxfrags=5 --seed=1 < output-testing/ibol.species.json > output-testing/ibol.species.s1.json

testing1:
	# testing the effect of binary features
	# also testing the effect of 3-mers
	python $(EXP_SHARED)/json2arff.py --kmer=3,6 --taxlevel=family --outtrain=$(TMP_TESTING)/family.testing.big.arff --intrain=output-testing/res50k.family.s1.json --freq
	java -Xmx13G weka.filters.unsupervised.instance.ReservoirSample -S 1 -Z $(SAMPLE_SIZE) < $(TMP_TESTING)/family.testing.big.arff > output-testing/family.testing.arff
	
testing2:
	# testing the effect of 4,5-mers vs 4,5,6-mers
	python $(EXP_SHARED)/json2arff.py --kmer=4,5 --taxlevel=family --outtrain=$(TMP_TESTING)/family.45.big.arff --intrain=output-testing/res50k.family.s1.json
	java -Xmx13G weka.filters.unsupervised.instance.ReservoirSample -S 1 -Z $(SAMPLE_SIZE) < $(TMP_TESTING)/family.45.big.arff > output-testing/family.45.arff
	python $(EXP_SHARED)/json2arff.py --kmer=4,6 --taxlevel=family --outtrain=$(TMP_TESTING)/family.456.big.arff --intrain=output-testing/res50k.family.s1.json
	java -Xmx13G weka.filters.unsupervised.instance.ReservoirSample -S 1 -Z $(SAMPLE_SIZE) < $(TMP_TESTING)/family.456.big.arff > output-testing/family.456.arff
	
testing3:
	# test ambig nucleotides vs un-ambig
	python $(EXP_SHARED)/json2arff.py --kmer=4,6 --taxlevel=family --outtrain=$(TMP_TESTING)/family.456.ambig.big.arff --intrain=output-testing/res50k.family.s1.json --ambig
	java -Xmx13G weka.filters.unsupervised.instance.ReservoirSample -S 1 -Z $(SAMPLE_SIZE) < $(TMP_TESTING)/family.456.ambig.big.arff > output-testing/family.456.ambig.arff