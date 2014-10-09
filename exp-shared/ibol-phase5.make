.PHONY: all clean

all: $(OUT_FOLDER)/iBOL_phase_5.00_COI.json

$(OUT_FOLDER)/iBOL_phase_5.00_COI.tsv:
	cd output; unzip iBOL_phase_5.00_COI.tsv.zip

$(OUT_FOLDER)/iBOL_phase_5.00_COI.json.pre: $(OUT_FOLDER)/iBOL_phase_5.00_COI.tsv
	 python ibol-tsv2json.py < $(OUT_FOLDER)/iBOL_phase_5.00_COI.tsv > $(OUT_FOLDER)/iBOL_phase_5.00_COI.json.pre

clean:
	rm $(OUT_FOLDER)/iBOL_phase_5.00_COI.tsv
	rm $(OUT_FOLDER)/iBOL_phase_5.00_COI.json.pre
	rm $(OUT_FOLDER)/iBOL_phase_5.00_COI.json
