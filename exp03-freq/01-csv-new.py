import sys
import StringIO
import operator
import argparse
import math
import json

"""
Helper functions
"""

def err(st):
	sys.stderr.write( str(st) )
	sys.stderr.write("\n")

"""
Argument parsing
"""
	
parser = argparse.ArgumentParser(description='Takes as input a JSON FASTA, derives kmer features from the data and outputs a Weka ARFF.')
parser.add_argument('--outfile', dest='outfile', required=True, help='Output file for CSV file')
parser.add_argument('--infile', dest='infile', required=True, help='Input file in JSON FASTA')
parser.add_argument('--outlist', dest='outlist', required=True, help='No longer in use.')
parser.add_argument('--kmerrange', dest='kmerrange', required=True, help='Values of k to derive kmer features from e.g "3,5" for k = 3,4,5')
parser.add_argument('--taxlevel', dest='taxlevel', required=True, help='The taxonomic level to be used (either "genus", "order", or "family").')
parser.add_argument('--maxclass', dest='maxclass', required=True, help='The maximum number (M) of class values. Prefix with "c" for cutoff and "m" for max.')
args = parser.parse_args()

OUT_FILE = args.outfile
CUTOFF = False
if args.maxclass[0] == 'c':
	CUTOFF = True
elif args.maxclass[0] != 'm':
	err('You must prefix the --maxclass value with either "c" or "m". Terminating.')
	sys.exit(1)
	
MAX_CLASS = int(args.maxclass[1::])
KMER_RANGE = args.kmerrange.split(',')
TAX_LEVEL = args.taxlevel
KMER_MIN = int(KMER_RANGE[0])
KMER_MAX = int(KMER_RANGE[1])

contents = open(args.infile).read()
kmer_sets = [ set() for x in range(0, KMER_MAX + 1) ]
class_counts = dict()

"""
Building list of kmers and class values
"""

records = json.loads(contents)
err("Building list of class values")
for k in range(KMER_MIN, KMER_MAX+1):
	err("Building list of kmers for k = " + str(k))
	for rec in records:
		for x in range(0, len(rec['fasta']) - k + 1):
			kmer = str(rec['fasta'][x:x+k])
			if kmer not in kmer_sets[k] and kmer.count('N') != k:
				kmer_sets[k].add(kmer)				
		# only do this step once, since it's not related to kmer counting
		if k == KMER_MIN:
			classname = rec['taxinfo'][TAX_LEVEL]
			if classname not in class_counts:
				class_counts[classname] = 1
			else:
				class_counts[classname] += 1			
				
sorted_counts = sorted(class_counts.iteritems(), key=operator.itemgetter(1), reverse=True)
chosen_classnames = None
if CUTOFF:
	# in this case, MAX_CLASS is the count that class values must be at or above to be retained
	candidate = 0
	err("Retaining all class values with at least " + str(MAX_CLASS) + " occurences in the dataset")
	for i in range(0, len(sorted_counts)):
		if sorted_counts[i][1] < MAX_CLASS:
			chosen_classnames = set( [ tp[0] for tp in sorted_counts[0:i] ] )
			break
	err("Number of retained class values: " + str(MAX_CLASS) + "/" + str(len(sorted_counts)) )
else:
	# in this case, MAX_CLASS is the maximum index and anything before that is retained
	err("Limiting class values to " + str(MAX_CLASS) + " most common class values")
	chosen_classnames = set( [ tp[0] for tp in sorted_counts[0:MAX_CLASS] ] )

sys.exit(0)

"""
Write ARFF file. First do the header, then write the instances out
"""

err("Writing training file to " + OUT_FILE)
f_outfile = open(OUT_FILE, 'wb')
f_outfile.write("@relation " + OUT_FILE + "\n") 
for kmer_set in kmer_sets:	
	for kmer in kmer_set:
		f_outfile.write("@attribute " + kmer + "_f" + " numeric\n")
class_string = "@attribute class {" + ",".join(chosen_classnames) + "}\n"
f_outfile.write(class_string)
f_outfile.write("@data\n")

for rec in records:
	vector = [] # one particular instance
	classname = rec['taxinfo'][TAX_LEVEL]
	if classname in chosen_classnames:
		for k in range(KMER_MIN, KMER_MAX+1):
			kmer_set = kmer_sets[k]
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
					#log_prop = -1 * math.log(prop,10)
					vector.append( str(prop) )
		vector.append( classname )
		f_outfile.write( ",".join(vector) + "\n" )

f_outfile.close()
