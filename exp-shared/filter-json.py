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
parser.add_argument('--minlen', dest='minlen', required=True, type=int, help="Minimum length of sequences")
args = parser.parse_args()

records = json.loads( sys.stdin.read() )

dupe_count = 0
new_records = []
strings_seen = set()
class_counts = dict()
for rec in records:
	if rec['fasta'] in strings_seen:
		dupe_count += 1
		continue
	elif rec['fasta'] == "":
		continue
	elif len(rec['fasta']) < args.minlen:
		continue
	else:
		strings_seen.add( rec['fasta'] )
		new_records.append(rec)
err("Sequences ignored due to a previous duplicate: " + str(dupe_count))
err("Number of sequences retained: " + str(len(new_records)))

print json.dumps(new_records, sort_keys=True, indent=4, separators=(',', ': '))