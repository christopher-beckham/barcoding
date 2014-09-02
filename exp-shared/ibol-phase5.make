.PHONY: all clean

all: $(OUT_FOLDER)/iBOL_phase_5.00_COI.json

$(OUT_FOLDER)/iBOL_phase_5.00_COI.tsv:
	cd output; unzip iBOL_phase_5.00_COI.tsv.zip

$(OUT_FOLDER)/iBOL_phase_5.00_COI.json.pre: $(OUT_FOLDER)/iBOL_phase_5.00_COI.tsv
	 python ibol-tsv2json.py < $(OUT_FOLDER)/iBOL_phase_5.00_COI.tsv > $(OUT_FOLDER)/iBOL_phase_5.00_COI.json.pre

$(OUT_FOLDER)/iBOL_phase_5.00_COI.json: $(OUT_FOLDER)/iBOL_phase_5.00_COI.json.pre
	python chop-json-fasta.py --seed=0 --fraglen=300 < $(OUT_FOLDER)/iBOL_phase_5.00_COI.json.pre > $(OUT_FOLDER)/iBOL_phase_5.00_COI.json

clean:
	rm $(OUT_FOLDER)/iBOL_phase_5.00_COI.tsv
	rm $(OUT_FOLDER)/iBOL_phase_5.00_COI.json.pre
	rm $(OUT_FOLDER)/iBOL_phase_5.00_COI.json
