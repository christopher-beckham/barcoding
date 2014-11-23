prep:
	cd output
	mv TrainingTheClassifier/GenBankFamily_TrainingFiles/GenBank_Family.fasta GenBank_Family.fasta
	mv TrainingTheClassifier/GenBankBarcode_TrainingFiles/GenBank_Barcode.fasta GenBank_Barcode.fasta
	mv TrainingTheClassifier/GenBankGenus_TrainingFiles/GenBank_Genus.fasta GenBank_Genus.fasta
	rm -rf TrainingTheClassifier

tests:
	python porter-fasta2json.py --infile=output/GenBank_Family.fasta > output/genbank.family.json
	python porter-fasta2json.py --infile=output/GenBank_Genus.fasta > output/genbank.genus.json
	python $(EXP_SHARED)/filter-json.py --maxclass=c10 --taxlevel=family --minlen=0 --substr < output/genbank.family.json > output/genbank.family.clean.json
	python $(EXP_SHARED)/filter-json.py --maxclass=c10 --taxlevel=genus --minlen=0 --substr < output/genbank.genus.json > output/genbank.genus.clean.json
	python $(EXP_SHARED)/json2arff.py --outtrain=output/genbank.family.arff --intrain=output/genbank.family.clean.json --kmer=4,6 --taxlevel=family
	python $(EXP_SHARED)/json2arff.py --outtrain=output/genbank.genus.arff --intrain=output/genbank.genus.clean.json --kmer=4,6 --taxlevel=genus
	java -Xmx13G weka.filters.unsupervised.instance.ReservoirSample -S 1 -Z 30000 < output/genbank.family.arff > output/genbank.family.small.arff
	java -Xmx13G weka.filters.unsupervised.instance.ReservoirSample -S 1 -Z 30000 < output/genbank.genus.arff > output/genbank.genus.small.arff
	
tests2:
	java -Xmx16g weka.classifiers.trees.RandomForest -I 10 -K 0 -S 1 -num-slots 3 -x 2 -t output/genbank.family.small.arff > output/genbank.family.small.rf.result
	java -Xmx16g weka.classifiers.trees.RandomForest -I 10 -K 0 -S 1 -num-slots 3 -x 2 -t output/genbank.genus.small.arff > output/genbank.genus.small.rf.result