import sys
import json
import argparse
import random

random.seed(1)

def err(st):
	sys.stderr.write( str(st) )
	sys.stderr.write("\n")

parser = argparse.ArgumentParser(description="Do a 50-50 split of a JSON file (after shuffling its contents)")
parser.add_argument('--fold', dest='fold', required=True, type=int, help="Which fold to pick (either 1 or 2)")
args = parser.parse_args()

if args.fold not in [1,2]:
	err("--fold must be 1 or 2!")
	sys.exit(1)

records = json.loads( sys.stdin.read() )
random.shuffle(records)

if args.fold == 1:
	print json.dumps(records[ 0 : len(records)/2 ], sort_keys=True, indent=4, separators=(',', ': '))
elif args.fold == 2:
	print json.dumps(records[ len(records)/2 :: ], sort_keys=True, indent=4, separators=(',', ': '))