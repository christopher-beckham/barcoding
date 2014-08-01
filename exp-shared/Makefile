$(OUT_FOLDER)/res.json: $(OUT_FOLDER)/res.json.pre
	python 02-chop.py --seed=0 --fraglen=300 < $(OUT_FOLDER)/res.json.pre > $(OUT_FOLDER)/res.json

$(OUT_FOLDER)/res.json.pre:
	python 01-query.py --limit=50000 > $(OUT_FOLDER)/res.json.pre
