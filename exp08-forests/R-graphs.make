.PHONY: f-measure summary-arff test

files = ibol.nb.s1 ibol.rf.s1 res50k.genus.nb.s1 res50k.genus.rf.s1 res50k.family.nb.s1 res50k.family.rf.s1
arffs = ibol.s1.arff res50k.family.s1.arff res50k.genus.s1.arff

f-measure: files
	for file in $(files); do \
		if [ ! -e results/$$file.result ]; then \
			echo "Cannot find file "results/$$file.result; \
			exit 1; \
		fi; \
		python parse-measures.py < results/$$file.result > R/f-measures/$$file.fmeasure; \
	done; \
	cd R; RScript f-measures.R
	
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