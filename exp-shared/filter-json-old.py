import sys
import StringIO
import random
import argparse
import json
import operator

def err(st):
	sys.stderr.write( str(st) )
	sys.stderr.write("\n")

parser = argparse.ArgumentParser(description="Remove dupes")
parser.add_argument('--maxclass', dest='maxclass', required=True, help='The maximum number (M) of class values. Prefix with "c" for cutoff and "m" for max.')
parser.add_argument('--taxlevel', dest='taxlevel', required=True, help='The taxonomic level to be used (either "genus", "order", or "family").')
parser.add_argument('--minlen', dest='minlen', required=True, type=int, help="Minimum length of sequences")
args = parser.parse_args()

MAX_CLASS = int(args.maxclass[1::])
CUTOFF = False
if args.maxclass[0] == 'c':
	CUTOFF = True
elif args.maxclass[0] != 'm':
	err('You must prefix the --maxclass value with either "c" or "m". Terminating.')
	sys.exit(1)

records = json.loads( sys.stdin.read() )


dupe_count = 0
new_records = []
strings_seen = set()
class_counts = dict()
for rec in records:
	classname = rec['taxinfo'][args.taxlevel]
	if rec['fasta'] in strings_seen:
		dupe_count += 1
		continue
	elif rec['fasta'] == "":
		continue
	elif len(rec['fasta']) < args.minlen:
		continue
	elif classname == "NA" or classname == "":
		continue
	else:
		strings_seen.add( rec['fasta'] )
		if classname not in class_counts:
			class_counts[classname] = 1
		else:
			class_counts[classname] += 1
		new_records.append(rec)
err("Sequences ignored due to a previous duplicate: " + str(dupe_count))
err("Number of sequences retained: " + str(len(new_records)))


sorted_counts = sorted(class_counts.iteritems(), key=operator.itemgetter(1), reverse=True)
chosen_classnames = None
if CUTOFF:
	err("Retaining all class values with at least " + str(MAX_CLASS) + " occurences in the dataset")
	for i in range(0, len(sorted_counts)):
		if sorted_counts[i][1] < MAX_CLASS:
			chosen_classnames = set( [ tp[0] for tp in sorted_counts[0:i] ] )
			err("Number of retained class values: " + str(i) + "/" + str(len(sorted_counts)) )
			break
else:
	err("Limiting class values to " + str(MAX_CLASS) + " most common class values")
	chosen_classnames = set( [ tp[0] for tp in sorted_counts[0:MAX_CLASS] ] )
		
final_records = []
for rec in new_records:
	if rec['taxinfo'][args.taxlevel] in chosen_classnames:
		final_records.append(rec)
		

print json.dumps(final_records, sort_keys=True, indent=4, separators=(',', ': '))