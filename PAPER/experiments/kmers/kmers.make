.PHONY : json arff

###########
# GLOBALS #
###########

TRAIN_FOLD = 1
TEST_FOLD = 2

json:
	python $(EXP_SHARED)/split-json.py --fold=$(TEST_FOLD) < $(OUT_FOLDER)/res50k.json.clean > output/res50k.json
	python $(EXP_SHARED)/split-json.py --fold=$(TEST_FOLD) < $(OUT_FOLDER)/ibol.json.clean > output/ibol.json
	
	for rank in family genus; do \
		python $(EXP_SHARED)/filter-json.py --maxclass=c10 --taxlevel=$$rank --minlen=300 --substr < output/res50k.json > output/res50k.$$rank.json; \
	done; \
	python $(EXP_SHARED)/chop-json.py --fraglen=300 --maxfrags=5 --seed=1 < output/res50k.family.json > output/res50k.family.s1.json
	python $(EXP_SHARED)/chop-json.py --fraglen=300 --maxfrags=5 --seed=1 < output/res50k.genus.json > output/res50k.genus.s1.json
	
	python $(EXP_SHARED)/filter-json.py --maxclass=c10 --taxlevel=species --minlen=300 --substr < output/ibol.json > output/ibol.species.json
	python $(EXP_SHARED)/chop-json.py --fraglen=300 --maxfrags=5 --seed=1 < output/ibol.species.json > output/ibol.species.s1.json
	
arff:
	# The point of this experiment is to see what kind of accuracy do we get when we vary
	# both the sequence length, and the value of k.
	#
	python $(EXP_SHARED)/split-json.py --fold=$(TEST_FOLD) < $(OUT_FOLDER)/res50k.json.clean > output/res50k.json
	for SEQ_LENGTH in 150 300 450 600; do \
		for K in 3 4 5 6; do \
			echo "Seq length = "$$SEQ_LENGTH", k = "$$K; \
			python $(EXP_SHARED)/filter-json.py --maxclass=c10 --taxlevel=family --minlen=$$SEQ_LENGTH --substr < output/res50k.json > output/res50k.family.json; \
			python $(EXP_SHARED)/chop-json.py --fraglen=$$SEQ_LENGTH --maxfrags=1 --seed=1 < output/res50k.family.json > output/res50k.family.s1.json; \
			python $(EXP_SHARED)/json2arff.py --kmer=$$K,$$K --intrain=output/res50k.family.s1.json --outtrain=output/res50k.family.k$$K.seq$$SEQ_LENGTH.arff --taxlevel=family --freq; \
		done; \
	done; \