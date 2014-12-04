import sys
import json

jsons = json.loads( sys.stdin.read() )

i = 0
for entry in jsons:
	header = []
	for key in entry['taxinfo']:
		header.append(key + "=" + entry['taxinfo'][key])
	print ">" + str(i) + "|" + "|".join(header)
	print entry['fasta']
	i += 1