.PHONY : all clean

RESULTS = results/new
NAIVE_01 = naived-noig-300class.result
NAIVE_02 = naived-ig500-300class.result
NAIVE_03 = naived-ig100-300class.result

all: $(RESULTS)/$(NAIVE_01)

output/res50k.arff:
	$(MAKE) -C $(EXP_SHARED) -f res50k.make # take care of the res50k.json dep
	python 01-csv-new.py --kmer="3,5" --taxlevel="genus" --outfile=output/res50k.arff --outlist=null --infile=$(OUT_FOLDER)/res50k.json --maxclass=300

$(RESULTS)/$(NAIVE_01): output/res50k.arff
	java -Xmx6000M weka.classifiers.bayes.NaiveBayes -D -t output/res50k.arff -x 3 -v -o > $(RESULTS)/$(NAIVE_01)

clean:
	rm output/res50k.arff
