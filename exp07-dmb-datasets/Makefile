.PHONY: birds cyp

SEED_MIN = 1
SEED_MAX = 5

# MAC OS X USERS - you may have to change seq to gseq
SEQ = seq

cyp-arff:
	python fasta2json.py --infile=data/cypraeidae/CypAll.fasta > output/CypAll.json.pre
	#python $EXP_SHARED/json2arff.py --infile=output/CypAll.json --outfile=output/CypAll.arff --kmerrange=3,5 --maxclass=m100000
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=4 'python $(EXP_SHARED)/chop-json-fasta.py --fraglen=300 --seed={} < output/CypAll.json.pre > output/CypAll.s{}.json'
	$(SEQ) $(SEED_MIN) $(SEED_MAX) | parallel --max-proc=2 'python $(EXP_SHARED)/json2arff.py --kmer="3,5" --taxlevel="species" --outfile=output/CypAll.s{}.arff --infile=output/CypAll.s{}.json --maxclass="m100000"'
	
birds-prep:
	python fasta2json.py --infile=data/birds/ATrain.fas > output/birds.train.json
	python fasta2json.py --infile=data/birds/ATest.fas > output/birds.test.json
	python $(EXP_SHARED)/json2arff.py --outtrain=output/birds.train.arff --intrain=output/birds.train.json --kmerrange=3,5 --taxlevel=species --maxclass=m10000 --outtest=output/birds.test.arff --intest=output/birds.test.json

birds-train:
	java -Xmx6000M weka.classifiers.meta.AttributeSelectedClassifier -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0 -N 500" -W weka.classifiers.bayes.NaiveBayes -t output/birds.train.arff -T output/birds.test.arff -o -v -no-predictions -- -D > results/birds.test.result
	
cyp-prep:
	python fasta2json.py --infile=data/cypraeidae/CypraeidaeTrain.fasta > output/cyp.train.json
	python fasta2json.py --infile=data/cypraeidae/CypraeidaeTest.fasta > output/cyp.test.json
	python $(EXP_SHARED)/json2arff.py --outtrain=output/cyp.train.arff --intrain=output/cyp.train.json --kmerrange=3,5 --taxlevel=species --maxclass=m10000 --outtest=output/cyp.test.arff --intest=output/cyp.test.json
	
cyp-train:
	java -Xmx6000M weka.classifiers.meta.AttributeSelectedClassifier -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0 -N 500" -W weka.classifiers.bayes.NaiveBayes -t output/cyp.train.arff -T output/cyp.test.arff -o -v -no-predictions -- -D > results/cyp.test.result