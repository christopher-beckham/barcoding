import json
import sys

ambig_nuc = set(['R', 'Y', 'S', 'W', 'K', 'M', 'B', 'D', 'H', 'V', 'N'])

js = json.loads( open(sys.argv[1]).read() )
classes = dict()

ambigs = 0
non_ambigs = 0
ambig_seqs = set()

for rec in js:
	seq = rec['fasta']
	for n in seq:
		if n in ambig_nuc:
			ambigs += 1
			ambig_seqs.add(seq)
		else:
			non_ambigs += 1
		
print "Number of ambig nucleotides:",		
print float(ambigs)

print "Total number of nucleotides:",
print float(ambigs+non_ambigs)

print "Sequences with ambig nucleotides:",
print len(ambig_seqs)