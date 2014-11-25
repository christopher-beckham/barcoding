"""
This script seems messy... could do with a clean-up!
"""

import sys
import StringIO
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
parser.add_argument('--substr', dest='substr', action='store_true')
args = parser.parse_args()

MAX_CLASS = int(args.maxclass[1::])
CUTOFF = False
if args.maxclass[0] == 'c':
	CUTOFF = True
elif args.maxclass[0] != 'm':
	err('You must prefix the --maxclass value with either "c" or "m". Terminating.')
	sys.exit(1)

records = json.loads( sys.stdin.read() )

db = dict()
for rec in records:
	classname = rec['taxinfo'][args.taxlevel]
	if classname == "NA" or classname == "":
		continue
	if classname not in db:
		db[classname] = []
	db[classname].append(rec)
	
new_db = dict()
dupe_count = 0
retained = 0
err("Looking at each class, getting rid of duplicate sequences")
for classname in db:
	strings_seen = set()
	entries = db[classname]
	for entry in entries:
		if entry['fasta'] in strings_seen:
			dupe_count += 1
			continue
		elif entry['fasta'] == "":
			continue
		elif len(entry['fasta']) < args.minlen:
			continue
		else:
			strings_seen.add( entry['fasta'] )
			if classname not in new_db:
				new_db[classname] = []
			new_db[classname].append(entry)
			retained += 1
err("Sequences ignored due to a previous duplicate: " + str(dupe_count))
err("Number of sequences retained: " + str(retained))

if(args.substr):
	err("Looking at each class, getting rid of substrings")
	substring_count = 0
	new_new_db = dict()
	for classname in new_db:
		#err(classname) # hide
		entries = new_db[classname]
		sorted_seqs = sorted( [ entry['fasta'] for entry in entries ], key=len )
		ignore_set = set()
		for x in range(0, len(sorted_seqs)):
			for y in range(0, x):
				if len(sorted_seqs[y]) >= sorted_seqs[x]:
					break
				elif sorted_seqs[y] in sorted_seqs[x]:
					ignore_set.add( sorted_seqs[y] )
					substring_count += 1
		new_new_db[classname] = []
		for entry in entries:
			if entry['fasta'] not in ignore_set:
				new_new_db[classname].append(entry)		
	err("Number of substrings removed: " + str(substring_count))
	new_db = new_new_db

class_counts = dict()
for classname in new_db:
	class_counts[classname] = len(new_db[classname])

sorted_counts = sorted(class_counts.iteritems(), key=operator.itemgetter(1), reverse=True)
chosen_classnames = None
if CUTOFF:
	err("Retaining all class values with at least " + str(MAX_CLASS) + " occurences in the dataset")
	for i in range(0, len(sorted_counts)):
		if sorted_counts[i][1] < MAX_CLASS:
			chosen_classnames = set( [ tp[0] for tp in sorted_counts[0:i] ] )
			err("Number of retained class values: " + str(i) + "/" + str(len(sorted_counts)) )
			break
	if chosen_classnames == None:
		chosen_classnames = set( [tp[0] for tp in sorted_counts] )
else:
	err("Limiting class values to " + str(MAX_CLASS) + " most common class values")
	chosen_classnames = set( [ tp[0] for tp in sorted_counts[0:MAX_CLASS] ] )
	
final_records = []
for classname in new_db:
	if classname in chosen_classnames:
		for entry in new_db[classname]:
			final_records.append(entry)
err("Final number of sequences: " + str(len(final_records)) )		

print json.dumps(final_records, sort_keys=True, indent=4, separators=(',', ': '))