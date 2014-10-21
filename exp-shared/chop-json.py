import sys
import StringIO
import random
import argparse
import json

parser = argparse.ArgumentParser(description="Create variable length reads")
parser.add_argument('--fraglen', dest='fraglen', required=True, type=int, help="What length the fragments should be (in bp)")
parser.add_argument('--maxfrags', dest='maxfrags', required=True, type=int, help="Maxiumum fragments to generate per sequence")
parser.add_argument('--seed', dest='seed', required=True, type=int, help="Seed for the RNG")
args = parser.parse_args()
random.seed(args.seed)

records = json.loads( sys.stdin.read() )

new_records = []

for rec in records:

	rec_fragments = set()
	for k in range(0, len(rec['fasta']) - args.fraglen + 1):
		rec_fragments.add( rec['fasta'][k : k + args.fraglen] )

	rec_fragments = list(rec_fragments)
	random.shuffle(rec_fragments)
	rec_fragments = rec_fragments[0 : args.maxfrags]
		
	for fragment in rec_fragments:
		new_sequence = dict(rec) # deep copy json entry
		new_sequence['fasta'] = fragment
		new_records.append(new_sequence)


print json.dumps(new_records, sort_keys=True, indent=4, separators=(',', ': '))