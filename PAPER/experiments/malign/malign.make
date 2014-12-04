.PHONY : arff

###########
# GLOBALS #
###########

TRAIN_FOLD = 1
TEST_FOLD = 2
	
arff:
	python $(EXP_SHARED)/filter-json.py --maxclass=c10 --taxlevel=family --minlen=0 --substr < $(OUT_FOLDER)/res50k.json.pre > output/res50k.family.json
	python $EXP_SHARED/json2fasta.py < res50k.family.json > res50k.family.fasta
	mafft --parttree --alga --retree 2 --partsize 1000 --thread 2 res50k.family.fasta > res50k.family.fasta.out