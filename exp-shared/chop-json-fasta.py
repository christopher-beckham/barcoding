import sys
import StringIO
import random
import argparse
import json

parser = argparse.ArgumentParser(description="Create variable length reads")
parser.add_argument('--fraglen', dest='fraglen', required=True, type=int, help="Fragment lengths to randomly sample from (0 = don't use this)")
parser.add_argument('--seed', dest='seed', required=True, type=int, help="Seed for the RNG")
args = parser.parse_args()
FRAGLEN = args.fraglen
SEED = args.seed

random.seed(SEED)

records = json.loads( sys.stdin.read() )
nc = 0

new_records = []

for rec in records:

	if len(rec['fasta']) < FRAGLEN:
		continue
		
	if 'N' in rec['fasta'] or 'n' in rec['fasta']:
		nc += 1
		continue

	if FRAGLEN > 0:
		idx = random.randint(0, len(rec['fasta']) - FRAGLEN)
		rec['fasta'] = rec['fasta'][ idx : idx + FRAGLEN ]
		
	new_records.append(rec)
		
sys.stderr.write("Number of sequences with N's: " + str(nc) + "\n")

print json.dumps(new_records)