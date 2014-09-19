.PHONY: clean

$(OUT_FOLDER)/res50k.json: $(OUT_FOLDER)/res50k.json.pre
	python process-json.py --seed=0 --fraglen=300 < $(OUT_FOLDER)/res50k.json.pre > $(OUT_FOLDER)/res50k.json

$(OUT_FOLDER)/res50k.json.pre:
	python entrez2json.py --limit=50000 > $(OUT_FOLDER)/res50k.json.pre

clean:
	rm $(OUT_FOLDER)/res50k.json.pre $(OUT_FOLDER)/res50k.json
