import sys
import json

jsons = json.loads( sys.stdin.read() )

for entry in jsons:
	print '>lcl|' + entry['nucid']
	print entry['fasta']