from Bio import SeqIO
from Bio import Seq

import sys
import StringIO
import random
import argparse

parser = argparse.ArgumentParser(description="Create variable length reads")
parser.add_argument('--fraglen', dest='fraglen', required=True, type=int, help="Fragment lengths to randomly sample from (0 = don't use this)")
parser.add_argument('--seed', dest='seed', required=True, type=int, help="Seed for the RNG")
args = parser.parse_args()
FRAGLEN = args.fraglen
SEED = args.seed

random.seed(SEED)

fstring = StringIO.StringIO( sys.stdin.read() )

nc = 0

records = SeqIO.parse(fstring, "fasta")
for rec in records:

	if len(rec.seq) < FRAGLEN:
		continue
		
	if 'N' in rec.seq or 'n' in rec.seq:
		nc += 1
		continue

	if FRAGLEN > 0:
		idx = random.randint(0, len(rec.seq) - FRAGLEN)
		print '>' + rec.id
		print rec.seq[ idx : idx + FRAGLEN ]
	else:
		print '>' + rec.id
		print rec.seq
		
sys.stderr.write("Number of sequences with N's: " + str(nc) + "\n")