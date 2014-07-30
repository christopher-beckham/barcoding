$(OUT_FOLDER)/res.fasta: $(OUT_FOLDER)/res.fasta.pre
	python 02-chop.py --seed=0 --fraglen=$(EXP01_FRAGLEN) < $(OUT_FOLDER)/res.fasta.pre > $(OUT_FOLDER)/res.fasta

$(OUT_FOLDER)/res.fasta.pre:
	python 01-query.py --limit=$(EXP01_NUCLIMIT) > $(OUT_FOLDER)/res.fasta.pre
