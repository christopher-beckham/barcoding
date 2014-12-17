import sys
import StringIO
import argparse
import json
import operator
import argparse

def err(st):
	sys.stderr.write( str(st) )
	sys.stderr.write("\n")

parser = argparse.ArgumentParser(description="Remove dupes")
parser.add_argument('--substr', dest='substr', action='store_true')
args = parser.parse_args()

entries = json.loads( sys.stdin.read() )

strings_seen = set()
new_records = []
retained = 0
dupe_count = 0
for entry in entries:
	if entry['fasta'] in strings_seen:
		dupe_count += 1
		continue
	elif entry['fasta'] == "":
		continue
	else:
		strings_seen.add( entry['fasta'] )
		new_records.append(entry)
		retained += 1
err("Sequences ignored due to a previous duplicate: " + str(dupe_count))
err("Number of sequences retained: " + str(retained))
err("Percentage of duplicates: " + str( float(dupe_count) / float(len(entries)) ) )

if args.substr:
	err("Getting rid of substrings...")
	substring_count = 0
	new_new_records = []

	sorted_seqs = sorted( [ entry['fasta'] for entry in new_records ], key=len )
	ignore_set = set()
	for x in range(0, len(sorted_seqs)):
		for y in range(0, x):
			if len(sorted_seqs[y]) >= sorted_seqs[x]:
				break
			elif sorted_seqs[y] in sorted_seqs[x]:
				ignore_set.add( sorted_seqs[y] )
				substring_count += 1
	for entry in new_records:
		if entry['fasta'] not in ignore_set:
			new_new_records.append(entry)		
	err("Number of substrings removed: " + str(substring_count))

	print json.dumps(new_new_records, sort_keys=True, indent=4, separators=(',', ': '))
else:
	print json.dumps(new_records, sort_keys=True, indent=4, separators=(',', ': '))