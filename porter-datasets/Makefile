prep:
	cd output
	mv TrainingTheClassifier/GenBankFamily_TrainingFiles/GenBank_Family.fasta GenBank_Family.fasta
	mv TrainingTheClassifier/GenBankBarcode_TrainingFiles/GenBank_Barcode.fasta GenBank_Barcode.fasta
	mv TrainingTheClassifier/GenBankGenus_TrainingFiles/GenBank_Genus.fasta GenBank_Genus.fasta
	rm -rf TrainingTheClassifier

tests:
	python porter-fasta2json.py --infile=output/GenBank_Genus.fasta --taxlevel=genus > output/genus.fasta
	python porter-fasta2json.py --infile=output/GenBank_Family.fasta --taxlevel=family > output/family.fasta
	python $(EXP_SHARED)/process-json.py --fraglen=0 --seed=1 < output/genus.fasta > /dev/null
	python $(EXP_SHARED)/process-json.py --fraglen=0 --seed=1 < output/family.fasta > /dev/null