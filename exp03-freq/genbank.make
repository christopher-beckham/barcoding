.PHONY : all clean family genus

RESULTS = results/genbank
OUTFILE = res50k
INFILE = res50k

all: family genus

output/$(OUTFILE).genus.arff:
	$(MAKE) -C $(EXP_SHARED) -f res50k.make
	$(EXP_SHARED)/json2arff.py --kmer="3,5" --taxlevel="genus" --outfile=output/$(OUTFILE).genus.arff --outlist=null --infile=$(OUT_FOLDER)/$(INFILE).json --maxclass="c20"

output/$(OUTFILE).family.arff:
	$(MAKE) -C $(EXP_SHARED) -f res50k.make # duplicate
	$(EXP_SHARED)/json2arff.py --kmer="3,5" --taxlevel="family" --outfile=output/$(OUTFILE).family.arff --outlist=null --infile=$(OUT_FOLDER)/$(INFILE).json --maxclass="c20"

family: output/$(OUTFILE).family.arff

	java -Xmx6000M weka.classifiers.rules.ZeroR -t output/$(OUTFILE).family.arff > $(RESULTS)/family-zeror.result

	java -Xmx6000M weka.classifiers.meta.AttributeSelectedClassifier -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N -1" -W weka.classifiers.bayes.NaiveBayes -x 2 -t output/$(OUTFILE).family.arff -v -o -- -D > $(RESULTS)/family-naived-ig0.result
	
	java -Xmx6000M weka.classifiers.meta.AttributeSelectedClassifier -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N 500" -W weka.classifiers.bayes.NaiveBayes -x 2 -t output/$(OUTFILE).family.arff -v -o -- -D > $(RESULTS)/family-naived-ig500.result
		
	java -Xmx6000M weka.classifiers.meta.AttributeSelectedClassifier -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N 100" -W weka.classifiers.bayes.NaiveBayes -x 2 -t output/$(OUTFILE).family.arff -v -o -- -D > $(RESULTS)/family-naived-ig100.result
	
genus: output/$(OUTFILE).genus.arff

	java -Xmx6000M weka.classifiers.rules.ZeroR -t output/$(OUTFILE).genus.arff > $(RESULTS)/genus-zeror.result

	java -Xmx6000M weka.classifiers.meta.AttributeSelectedClassifier -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N -1" -W weka.classifiers.bayes.NaiveBayes -x 2 -t output/$(OUTFILE).genus.arff -v -o -- -D > $(RESULTS)/genus-naived-ig0.result
	
	java -Xmx6000M weka.classifiers.meta.AttributeSelectedClassifier -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N 500" -W weka.classifiers.bayes.NaiveBayes -x 2 -t output/$(OUTFILE).genus.arff -v -o -- -D > $(RESULTS)/genus-naived-ig500.result
		
	java -Xmx6000M weka.classifiers.meta.AttributeSelectedClassifier -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N 100" -W weka.classifiers.bayes.NaiveBayes -x 2 -t output/$(OUTFILE).genus.arff -v -o -- -D > $(RESULTS)/genus-naived-ig100.result

clean:
	rm output/res50k.arff

