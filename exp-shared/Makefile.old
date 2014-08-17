json:
	python 01-query.py --limit=50000 > $(OUT_FOLDER)/res50k.json.pre
	python 02-chop.py --seed=0 --fraglen=300 < $(OUT_FOLDER)/res50k.json.pre > $(OUT_FOLDER)/res50k.json

fasta:	
	python json2fasta.py < $(OUT_FOLDER)/res50k.json > $(OUT_FOLDER)/res50k.fasta
