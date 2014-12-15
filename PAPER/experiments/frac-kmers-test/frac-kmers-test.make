.PHONY : arff

###########
# GLOBALS #
###########

TRAIN_FOLD = 1
TEST_FOLD = 2
	
arff:
	for SEQ_LENGTH in 600; do \
		echo "Seq length = "$$SEQ_LENGTH; \
		for tax in family; do \
			python $(EXP_SHARED)/filter-json.py --maxclass=c10 --taxlevel=$$tax --minlen=$$SEQ_LENGTH --substr < $(OUT_FOLDER)/res50k.json.pre > output/res50k.$$tax.json; \
			if [ $$SEQ_LENGTH == 600 ]; then \
				cp output/res50k.$$tax.json output/res50k.$$tax.s1.json; \
			else \
				python $(EXP_SHARED)/chop-json.py --fraglen=$$SEQ_LENGTH --maxfrags=1 --seed=1 < output/res50k.$$tax.json > output/res50k.$$tax.s1.json; \
			fi; \
			python $(EXP_SHARED)/json2arff.py --kmer=3,3 --intrain=output/res50k.$$tax.s1.json --outtrain=output/res50k.$$tax.seq$$SEQ_LENGTH.k33.arff --taxlevel=$$tax --freq; \
			python $(EXP_SHARED)/json2arff.py --kmer=5,5 --intrain=output/res50k.$$tax.s1.json --outtrain=output/res50k.$$tax.seq$$SEQ_LENGTH.k55.arff --taxlevel=$$tax --freq; \
			python $(EXP_SHARED)/json2arff-frac.py --kmer=5,5 --intrain=output/res50k.$$tax.s1.json --outtrain=output/res50k.$$tax.seq$$SEQ_LENGTH.kf35.arff --taxlevel=$$tax --freq; \
		done; \
	done; \
	