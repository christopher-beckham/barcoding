.PHONY: f-measure summary-arff info-gain files arffs

files = ibol.nb ibol.rf res50k.genus.nb res50k.genus.rf res50k.family.nb res50k.family.rf
arffs = ibol.s1.arff res50k.family.s1.arff res50k.genus.s1.arff

SEED_MIN = 1
SEED_MAX = 5

f-measure:
	for file in $(files); do \
		for seed in {$(SEED_MIN)..$(SEED_MAX)}; do \
			if [ ! -e results/$$file.s$$seed.result ]; then \
				echo "Cannot find file "results/$$file.s$$seed.result; \
				exit 1; \
			fi; \
			python parse-measures.py < results/$$file.s$$seed.result > R/f-measures/$$file.s$$seed.fmeasure; \
		done; \
	done; \
	#cd R; RScript f-measures.R
	
summary-arff:
	for file in $(arffs); do \
		if [ ! -e output/$$file ]; then \
			echo "Cannot find file "output/$$file; \
			exit 1; \
		fi; \
	done; \
	cd R; RScript summary.arff.R
	
info-gain:
	python parse-results.py "results/res50k.genus.ig*.s1.result" > R/info-gain/info-gain.csv