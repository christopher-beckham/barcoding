import sys
import StringIO
import operator
import argparse
import math
import json

parser = argparse.ArgumentParser(description='Allows conversion of numeric features to binary ones')
parser.add_argument('--infile', dest='infile', required=True, help='Input ARFF file')
parser.add_argument('--kmer', dest='kmer', required=True, help='Values of k to binarise (comma separated)')
args = parser.parse_args()

kmers = [int(x) for x in args.kmer.split(',')]

f = open(args.infile)
relation = f.readline().rstrip()
headers = []
for line in f:
	line = line.rstrip()
	if line == "@data":
		break
	else:
		headers.append(line.split())
data = []
for line in f:
	line = line.rstrip()
	data.append( line.split(',') )
f.close()

# examine headers
idxs = []
for i, elem in enumerate(headers):
	elem = elem[1]
	if elem != "class":
		elem = elem.replace("_f","")
		if len(elem) in kmers:
			idxs.append(i)

# change headers
for idx in idxs:
	headers[idx][2] = "{0,1}"

for i in range(0, len(data)):
	for idx in idxs:
		if float(data[i][idx]) > 0:
			data[i][idx] = '1'

print relation
for header in headers:
	print " ".join(header)
print "@data"
for dat in data:
	print ",".join(dat)
