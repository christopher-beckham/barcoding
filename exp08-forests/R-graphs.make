.PHONY: files
files = ibol.nb.s1 ibol.rf.s1 res50k.genus.nb.s1 res50k.genus.rf.s1 res50k.family.nb.s1 res50k.family.rf.s1

f-measure: files
	for file in $(files); do \
		python parse-measures.py < results/$$file.result > R/f-measures/$$file.fmeasure; \
	done