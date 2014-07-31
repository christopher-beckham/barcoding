import sys
import StringIO
import operator
import argparse
import math
import json

def err(st):
	sys.stderr.write( str(st) )
	sys.stderr.write("\n")

parser = argparse.ArgumentParser(description="Create kmer freq csv from res.fasta")
parser.add_argument('--outfile', dest='outfile', required=True, help="Output file for training CSV")
parser.add_argument('--outlist', dest='outlist', required=True, help="Output file for mer list")
parser.add_argument('--kmerrange', dest='kmerrange', required=True, help="kmer range")
parser.add_argument('--taxlevel', dest='taxlevel', required=True, help="The taxonomic levels to be used (i.e. family, genus, etc.)")
#parser.add_argument('--seed', dest='seed', type=int, required=True, help="Random seed for training/testing split")
args = parser.parse_args()

contents = sys.stdin.read()

kmerrange = args.kmerrange.split(',')
taxlevel = args.taxlevel

KMER_MIN = int(kmerrange[0])
KMER_MAX = int(kmerrange[1])
kmer_sets = [ set() for x in range(0, KMER_MAX - KMER_MIN + 1) ]


"""
There will likely be a lot of classes, so let's put a limit on them,
defined by MAX_CLASS. Only choose the most common classes, from 0 to
MAX_CLASS.
"""
MAX_CLASS = 40
class_counts = dict()

"""
For each value of n, i.e. n = 3, 4, ..., k, look at all the FASTA
sequences and extract the n-mers, then stash them in the set,
"globals". Also find the most common classes and keep a count in
another hash table, "class_counts".
"""
records = json.loads(contents)
for k in range(KMER_MIN, KMER_MAX+1):
	err("Processing k = " + str(k))
	for rec in records:
		for x in range(0, len(rec['fasta']) - k + 1):
			kmer = str(rec['fasta'][x:x+k])
			if kmer not in kmer_sets[k - KMER_MIN]:
				kmer_sets[k - KMER_MIN].add(kmer)				
		# only do this step once, since it's not related to kmer counting
		if k == KMER_MIN:
			classname = rec['taxinfo'][taxlevel]
			if classname not in class_counts:
				class_counts[classname] = 1
			else:
				class_counts[classname] += 1
		
sorted_counts = sorted(class_counts.iteritems(), key=operator.itemgetter(1), reverse=True)
chosen_classnames = set( [ tp[0] for tp in sorted_counts[0:MAX_CLASS] ] )

"""
Open a file defined by args.outlist, and write the mers to it
args.outlist is in the following format:

3mer_startidx, 3mer_endidx, 3mer_1, 3mer_2, ..., 3mer_p
4mer_startidx, 4mer_endidx, 4mer_1, 4mer_2, ..., 4mer_p
...
kmer_startidx, kmer_endidx, kmer_1, kmer_2, ..., kmer_p
"""
err("Writing kmer sets to " + args.outlist)
f_outlist = open(args.outlist, 'wb')
idx = 1
for kmer_set in kmer_sets:
	f_outlist.write(str(idx) + "," + str(len(kmer_set) + idx - 1) + "," );
	f_outlist.write(",".join(kmer_set))
	f_outlist.write("\n")
	idx += len(kmer_set)
f_outlist.close()

"""
Open a file defined by args.outfile, and write the training data
to it
"""
err("Writing training file to " + args.outfile)
f_outfile = open(args.outfile, 'wb')
labels = []
for kmer_set in kmer_sets:	
	for kmer in kmer_set:
		labels.append(kmer + "_f")
labels.append("class")
f_outfile.write( ",".join(labels) + "\n" )

for rec in records:
	vector = [] # one particular instance
	classname = rec['taxinfo'][taxlevel]
	if classname in chosen_classnames:
		for k in range(KMER_MIN, KMER_MAX+1):
			kmer_set = kmer_sets[k - KMER_MIN]
			hm = dict()
			for x in range(0, len(rec['fasta']) - k + 1):
				kmer = str(rec['fasta'][x:x+k])
				if kmer not in hm:
					hm[kmer] = 1
				else:
					hm[kmer] += 1
			for kmer in kmer_set:
				if kmer not in hm:
					vector.append('0')
				else:
					prop = float(hm[kmer]) / float( len(rec['fasta']) - k )
					log_prop = -1 * math.log(prop,10)
					vector.append( str(log_prop) )
		vector.append( classname )
		f_outfile.write( ",".join(vector) + "\n" )

f_outfile.close()
