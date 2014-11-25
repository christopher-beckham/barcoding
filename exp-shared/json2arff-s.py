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
	
def ambig(subseq):
	for k in subseq:
		if k in ambigs:
			return True
	return False

# http://stackoverflow.com/questions/24017363/how-to-test-if-one-string-is-a-subsequence-of-another-doesnt-have-to-be-subst
def is_subseq(x, y):
    it = iter(y)
    return all(any(c == ch for c in it) for ch in x)
	
ambigs = ['R', 'Y', 'S', 'W', 'K', 'M', 'B', 'D', 'H', 'V', 'N']

"""
Argument parsing
"""
	
parser = argparse.ArgumentParser(description='Takes as input a JSON FASTA, derives subseq features from the data and outputs a Weka ARFF.')
parser.add_argument('--outtrain', dest='outtrain', required=True, help='Output training ARFF file')
parser.add_argument('--intrain', dest='intrain', required=True, help='Input training JSON file')
parser.add_argument('--rang', dest='rang', required=True, help='Values of k to derive subseq features from e.g "3,5" for k = 3,4,5')
parser.add_argument('--taxlevel', dest='taxlevel', required=True, help='The taxonomic level to be used (either "genus", "order", or "family").')
parser.add_argument('--intest', dest='intest', help='Input testing JSON file')
parser.add_argument('--outtest', dest='outtest', help='Output testing ARFF file')
parser.add_argument('--freq', dest='freq', action='store_true', help='Use subseq frequencies instead of subseq binary')
parser.add_argument('--ambig', dest='ambig', action='store_true', help='Use ambiguous nucleotides as well')

args = parser.parse_args()

subseq_RANGE = args.rang.split(',')
subseq_MIN = int(subseq_RANGE[0])
subseq_MAX = int(subseq_RANGE[1])
assert subseq_MIN == subseq_MAX

training_records = json.loads( open(args.intrain).read() )
testing_records = None
if args.intest != None:
	testing_records = json.loads( open(args.intest).read() )
		
"""
Building list of subseqs and class values
"""

classnames = set()
subseq_sets = [ set() for x in range(0, subseq_MAX + 1) ]
for k in range(subseq_MIN, subseq_MAX+1):
	err("Building list of subseqs for k = " + str(k))
	for rec in training_records:
		#print rec
		classname = rec['taxinfo'][args.taxlevel]
		classnames.add(classname)
		for x in range(0, len(rec['fasta']), k):
			window = str(rec['fasta'][x:x+k])
			if len(window) < k:
				continue
			#print window
			subseq = "".join( [ window[i] for i in range(0, k, 3) ] )
			if args.ambig == False and ambig(subseq):
				continue
			if subseq not in subseq_sets[k]:
				subseq_sets[k].add(subseq)

"""
Write ARFF file. First do the header, then write the instances out
"""

def write_arff(records, subseq_sets, classname_set, outtrain_name):

	f_outtrain = open(outtrain_name, 'wb')
	f_outtrain.write("@relation " + outtrain_name + "\n") 
	for subseq_set in subseq_sets:	
		for subseq in subseq_set:
			if args.freq:
				f_outtrain.write("@attribute " + subseq + "_f" + " numeric\n")
			else:
				f_outtrain.write("@attribute " + subseq + " {0,1}\n")
	class_string = "@attribute class {" + ",".join( ['"' + x + '"' for x in classname_set] ) + "}\n"
	f_outtrain.write(class_string)
	f_outtrain.write("@data\n")

	err( len(subseq_set) )
	#sys.exit(0)
	progress = 0.0
	for rec in records:
		progress += 1
		err( str(progress/len(records)) + "%" )
		vector = [] # one particular instance
		classname = rec['taxinfo'][args.taxlevel]
		if classname in classname_set:
			for k in range(subseq_MIN, subseq_MAX+1):
				subseq_set = subseq_sets[k]
				#hm = dict()
				#for x in range(0, len(rec['fasta']) - k + 1):
				#	subseq = str(rec['fasta'][x:x+k])
				#	if subseq not in hm:
				#		hm[subseq] = 1
				#	else:
				#		hm[subseq] += 1
				for subseq in subseq_set:
					if is_subseq(subseq, rec['fasta']) == False:
						vector.append('0')
					else:
						vector.append('1')
			vector.append( '"' + classname + '"' )
			f_outtrain.write( ",".join(vector) + "\n" )

	f_outtrain.close()
	
err("Writing training file to " + args.outtrain)
write_arff(training_records, subseq_sets, classnames, args.outtrain)

if testing_records != None:
	err("Writing testing file to " + args.outtest)
	write_arff(testing_records, subseq_sets, classnames, args.outtest)