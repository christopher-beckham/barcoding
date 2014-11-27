.PHONY : json arff

###########
# GLOBALS #
###########

TEST_FOLD = 2
	
arff:
	for filename in res50k ibol; do \
		python $(EXP_SHARED)/split-json.py --fold=$(TEST_FOLD) < $(OUT_FOLDER)/$$filename.json.clean > output/$$filename.json; \
	done; \
	for SEQ_LENGTH in 150 300 450 600; do \
		echo "Seq length = "$$SEQ_LENGTH; \
		for tax in family genus; do \
			python $(EXP_SHARED)/filter-json.py --maxclass=c10 --taxlevel=$$tax --minlen=$$SEQ_LENGTH --substr < output/res50k.json > output/res50k.$$tax.json; \
			if [ $$SEQ_LENGTH == 600 ]; then \
				cp output/res50k.$$tax.json output/res50k.$$tax.s1.json; \
			else \
				python $(EXP_SHARED)/chop-json.py --fraglen=$$SEQ_LENGTH --maxfrags=1 --seed=1 < output/res50k.$$tax.json > output/res50k.$$tax.s1.json; \
			fi; \
			for K in 3 4 5 6; do \
				python $(EXP_SHARED)/json2arff.py --kmer=3,$$K --intrain=output/res50k.$$tax.s1.json --outtrain=output/res50k.$$tax.seq$$SEQ_LENGTH.k3$$K.arff --taxlevel=$$tax --freq; \
			done; \
		done; \
		for tax in species; do \
			python $(EXP_SHARED)/filter-json.py --maxclass=c10 --taxlevel=$$tax --minlen=$$SEQ_LENGTH --substr < output/ibol.json > output/ibol.$$tax.json; \
			if [ $$SEQ_LENGTH == 600 ]; then \
				cp output/ibol.$$tax.json output/ibol.$$tax.s1.json; \
			else \
				python $(EXP_SHARED)/chop-json.py --fraglen=$$SEQ_LENGTH --maxfrags=1 --seed=1 < output/ibol.$$tax.json > output/ibol.$$tax.s1.json; \
			fi; \
			for K in 3 4 5 6; do \
				python $(EXP_SHARED)/json2arff.py --kmer=3,$$K --intrain=output/ibol.$$tax.s1.json --outtrain=output/ibol.$$tax.seq$$SEQ_LENGTH.k3$$K.arff --taxlevel=$$tax --freq; \
			done; \
		done; \
	done; \
	