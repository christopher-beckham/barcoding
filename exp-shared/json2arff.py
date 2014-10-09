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
	
def ambig(kmer):
	for k in kmer:
		if k in ambigs:
			return True
	return False
	
ambigs = ['R', 'Y', 'S', 'W', 'K', 'M', 'B', 'D', 'H', 'V', 'N']

"""
Argument parsing
"""
	
parser = argparse.ArgumentParser(description='Takes as input a JSON FASTA, derives kmer features from the data and outputs a Weka ARFF.')
parser.add_argument('--outtrain', dest='outtrain', required=True, help='Output training ARFF file')
parser.add_argument('--intrain', dest='intrain', required=True, help='Input training JSON file')
#parser.add_argument('--outlist', dest='outlist', required=True, help='No longer in use.')
parser.add_argument('--kmerrange', dest='kmerrange', required=True, help='Values of k to derive kmer features from e.g "3,5" for k = 3,4,5')
parser.add_argument('--taxlevel', dest='taxlevel', required=True, help='The taxonomic level to be used (either "genus", "order", or "family").')
parser.add_argument('--maxclass', dest='maxclass', required=True, help='The maximum number (M) of class values. Prefix with "c" for cutoff and "m" for max.')

#parser.add_argument('--noambig', dest='noambig', action='store_true', help='Ignore ambiguous nucleotides when extracting features?')
parser.add_argument('--intest', dest='intest', help='Input testing JSON file')
parser.add_argument('--outtest', dest='outtest', help='Output testing ARFF file')

args = parser.parse_args()

CUTOFF = False
if args.maxclass[0] == 'c':
	CUTOFF = True
elif args.maxclass[0] != 'm':
	err('You must prefix the --maxclass value with either "c" or "m". Terminating.')
	sys.exit(1)
	
MAX_CLASS = int(args.maxclass[1::])
KMER_RANGE = args.kmerrange.split(',')
KMER_MIN = int(KMER_RANGE[0])
KMER_MAX = int(KMER_RANGE[1])

training_records = json.loads( open(args.intrain).read() )
testing_records = None
if args.intest != None:
	testing_records = json.loads( open(args.intest).read() )

"""
Class counts
"""

class_counts = dict()
err("Building list of class values")

for rec in training_records:
	classname = rec['taxinfo'][args.taxlevel]
	if classname == "NA" or classname == "":
		continue
		
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
			err("Number of retained class values: " + str(i) + "/" + str(len(sorted_counts)) )
			break
else:
	# in this case, MAX_CLASS is the maximum index and anything before that is retained
	err("Limiting class values to " + str(MAX_CLASS) + " most common class values")
	chosen_classnames = set( [ tp[0] for tp in sorted_counts[0:MAX_CLASS] ] )
		
"""
Building list of kmers and class values
"""

kmer_sets = [ set() for x in range(0, KMER_MAX + 1) ]
for k in range(KMER_MIN, KMER_MAX+1):
	err("Building list of kmers for k = " + str(k))
	for rec in training_records:
		classname = rec['taxinfo'][args.taxlevel]
		if classname in chosen_classnames:
			for x in range(0, len(rec['fasta']) - k + 1):
				kmer = str(rec['fasta'][x:x+k])
				#if args.noambig:
				if ambig(kmer):
					continue
				if kmer not in kmer_sets[k]:
					kmer_sets[k].add(kmer)

"""
Write ARFF file. First do the header, then write the instances out
"""

def write_arff(records, kmer_sets, classname_set, outtrain_name):

	f_outtrain = open(outtrain_name, 'wb')
	f_outtrain.write("@relation " + outtrain_name + "\n") 
	for kmer_set in kmer_sets:	
		for kmer in kmer_set:
			f_outtrain.write("@attribute " + kmer + "_f" + " numeric\n")
	class_string = "@attribute class {" + ",".join( ['"' + x + '"' for x in classname_set] ) + "}\n"
	f_outtrain.write(class_string)
	f_outtrain.write("@data\n")

	for rec in records:
		vector = [] # one particular instance
		classname = rec['taxinfo'][args.taxlevel]
		if classname in classname_set:
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
						#prop = -1 * math.log(prop,10)
						vector.append( str(prop) )
			vector.append( '"' + classname + '"' )
			f_outtrain.write( ",".join(vector) + "\n" )

	f_outtrain.close()
	
err("Writing training file to " + args.outtrain)
write_arff(training_records, kmer_sets, chosen_classnames, args.outtrain)

if testing_records != None:
	err("Writing testing file to " + args.outtest)
	write_arff(testing_records, kmer_sets, chosen_classnames, args.outtest)