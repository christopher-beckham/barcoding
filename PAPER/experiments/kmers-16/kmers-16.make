.PHONY : arff R f-measure

###########
# GLOBALS #
###########

TRAIN_FOLD = 1
TEST_FOLD = 2

#java -Xmx7g weka.filters.supervised.instance.StratifiedRemoveFolds -S 0 -N 2 -F $(TRAIN_FOLD) -c last -i output/res50k.$$tax.seq$$SEQ_LENGTH.k3$$K.arff > output/train/res50k.$$tax.seq$$SEQ_LENGTH.k3$$K.train.arff; \
#java -Xmx7g weka.filters.supervised.instance.StratifiedRemoveFolds -S 0 -N 2 -F $(TEST_FOLD) -c last -i output/res50k.$$tax.seq$$SEQ_LENGTH.k3$$K.arff > output/test/res50k.$$tax.seq$$SEQ_LENGTH.k3$$K.test.arff; \
#java -Xmx7g weka.filters.supervised.instance.StratifiedRemoveFolds -S 0 -N 2 -F $(TRAIN_FOLD) -c last -i output/ibol.$$tax.seq$$SEQ_LENGTH.k3$$K.arff > output/train/ibol.$$tax.seq$$SEQ_LENGTH.k3$$K.train.arff; \
#java -Xmx7g weka.filters.supervised.instance.StratifiedRemoveFolds -S 0 -N 2 -F $(TEST_FOLD) -c last -i output/ibol.$$tax.seq$$SEQ_LENGTH.k3$$K.arff > output/test/ibol.$$tax.seq$$SEQ_LENGTH.k3$$K.test.arff; \

arff:
	for SEQ_LENGTH in 150 300 450 600; do \
		echo "Seq length = "$$SEQ_LENGTH; \
		for tax in family genus; do \
			python $(EXP_SHARED)/filter-json.py --maxclass=c10 --taxlevel=$$tax --minlen=$$SEQ_LENGTH --substr < $(OUT_FOLDER)/res50k.json.pre > output/res50k.$$tax.json; \
			if [ $$SEQ_LENGTH == 600 ]; then \
				cp output/res50k.$$tax.json output/res50k.$$tax.s1.json; \
			else \
				python $(EXP_SHARED)/chop-json.py --fraglen=$$SEQ_LENGTH --maxfrags=1 --seed=1 < output/res50k.$$tax.json > output/res50k.$$tax.s1.json; \
			fi; \
			for K in 1 2 3 4 5 6; do \
				python $(EXP_SHARED)/json2arff.py --kmer=1,$$K --intrain=output/res50k.$$tax.s1.json --outtrain=output/res50k.$$tax.seq$$SEQ_LENGTH.k1$$K.arff --taxlevel=$$tax --freq; \
			done; \
		done; \
		for tax in species; do \
			python $(EXP_SHARED)/filter-json.py --maxclass=c10 --taxlevel=$$tax --minlen=$$SEQ_LENGTH --substr < $(OUT_FOLDER)/iBOL_phase_5.00_COI.json.pre > output/ibol.$$tax.json; \
			if [ $$SEQ_LENGTH == 600 ]; then \
				cp output/ibol.$$tax.json output/ibol.$$tax.s1.json; \
			else \
				python $(EXP_SHARED)/chop-json.py --fraglen=$$SEQ_LENGTH --maxfrags=1 --seed=1 < output/ibol.$$tax.json > output/ibol.$$tax.s1.json; \
			fi; \
			for K in 1 2 3 4 5 6; do \
				python $(EXP_SHARED)/json2arff.py --kmer=1,$$K --intrain=output/ibol.$$tax.s1.json --outtrain=output/ibol.$$tax.seq$$SEQ_LENGTH.k1$$K.arff --taxlevel=$$tax --freq; \
			done; \
		done; \
	done; \

