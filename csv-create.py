from sys import stdin
import sys

entries = stdin.read().split('\n')

KMER_SIZE = 3

arr = []
for x in range(0, len( entries[0].split(',')[1] ) - KMER_SIZE + 1):
	arr.append('f' + str(x))
arr.append("class")
print ",".join(arr)

num_features = len(arr)

for entry in entries:

	split = entry.split(',')
	
	if len(split) == 1:
		break
	
	name = split[0].split('__')[2]
	
	arr = []
	
	for x in range(0, len(split[1]) - KMER_SIZE + 1):	
		gram = split[1][ x : x + KMER_SIZE ]
		arr.append(gram)
		
	arr.append(name)

	assert len(arr) == num_features
	
	print ",".join(arr)