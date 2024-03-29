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
parser.add_argument('--kmerrange', dest='kmerrange', required=True, help='Values of k to derive kmer features from e.g "3,5" for k = 3,4,5')
parser.add_argument('--taxlevel', dest='taxlevel', required=True, help='The taxonomic level to be used (either "genus", "order", or "family").')
parser.add_argument('--intest', dest='intest', help='Input testing JSON file')
parser.add_argument('--outtest', dest='outtest', help='Output testing ARFF file')
parser.add_argument('--freq', dest='freq', action='store_true', help='Use kmer frequencies instead of kmer binary')
parser.add_argument('--ambig', dest='ambig', action='store_true', help='Use ambiguous nucleotides as well')

args = parser.parse_args()

KMER_RANGE = args.kmerrange.split(',')
KMER_MIN = int(KMER_RANGE[0])
KMER_MAX = int(KMER_RANGE[1])

training_records = json.loads( open(args.intrain).read() )
testing_records = None
if args.intest != None:
	testing_records = json.loads( open(args.intest).read() )
		
"""
Building list of kmers and class values
"""

def n_ify(st,x_size):
	st = list(st)
	for x in range(1, len(st), x_size+1):
		st[x:x+x_size] = "".join(['x' for i in range(0, x_size)])
	return "".join(st)

def match(n_st, full_st):
	assert len(n_st) == len(full_st)
	for x in range(0, len(full_st)):
		if n_st[x] == 'N':
			continue
		elif n_st[x] != full_st[x]:
			return False
	return True

classnames = set()
kmer_sets = [ set() for x in range(0, KMER_MAX + 1) ]
for k in range(KMER_MIN, KMER_MAX+1):
	err("Building list of kmers for k = " + str(k))
	for rec in training_records:
		classname = rec['taxinfo'][args.taxlevel]
		classnames.add(classname)
		for x in range(0, len(rec['fasta']) - k + 1):
			kmer = str(rec['fasta'][x:x+k])
			kmer = n_ify(kmer, 1)
			#print kmer
			if args.ambig == False and ambig(kmer):
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
			if args.freq:
				f_outtrain.write("@attribute " + kmer + "_f" + " numeric\n")
			else:
				f_outtrain.write("@attribute " + kmer + " {0,1}\n")
	class_string = "@attribute class {" + ",".join( ['"' + x + '"' for x in classname_set] ) + "}\n"
	f_outtrain.write(class_string)
	f_outtrain.write("@data\n")

	cc=0.0
	for rec in records:
		cc += 1
		sys.stderr.write( str( cc / len(records) ) + "\n" )
		vector = [] # one particular instance
		classname = rec['taxinfo'][args.taxlevel]
		if classname in classname_set:
			for k in range(KMER_MIN, KMER_MAX+1):
				kmer_set = kmer_sets[k]

				hm = dict()
				for x in range(0, len(rec['fasta']) - k + 1):
					kmer = str(rec['fasta'][x:x+k])
					kmer = n_ify(kmer, 1)
					if kmer not in hm:
						hm[kmer] = 1
					else:
						hm[kmer] += 1

				for kmer in kmer_set:
					if kmer not in hm:
						vector.append('0')
					else:
						if args.freq:
							prop = float(hm[kmer]) / float( len(rec['fasta']) - k + 1)
							vector.append( str(prop) )
						else:
							vector.append('1')
			#for v in range(0, len(vector)):
			#	vector[v] = float(vector[v]) / sum(vector)
			vector = [str(v) for v in vector] + ['"' + classname + '"']
			f_outtrain.write( ",".join(vector) + "\n" )

	f_outtrain.close()
	
err("Writing training file to " + args.outtrain)
write_arff(training_records, kmer_sets, classnames, args.outtrain)

if testing_records != None:
	err("Writing testing file to " + args.outtest)
	write_arff(testing_records, kmer_sets, classnames, args.outtest)