from sys import stdin
import sys
import operator

entries = stdin.read().split('\n')

KMER_SIZE = 3
MAX_CLASS = 20

arr = []
for x in range(0, len( entries[0].split(',')[1] ) - KMER_SIZE + 1):
	arr.append('f' + str(x))
arr.append("class")
print ",".join(arr)

"""
There will likely be a lot of classes, so let's put a limit on them,
defined by MAX_CLASS. Only choose the most common classes, from 0 to
MAX_CLASS.
"""

counts = dict()
for entry in entries:
	split = entry.split(',')
	if len(split) == 1:
		break	
	classname = split[0].split('__')[2]
	if classname not in counts:
		counts[classname] = 1
	else:
		counts[classname] += 1
		
sorted_counts = sorted(counts.iteritems(), key=operator.itemgetter(1), reverse=True)
chosen_classnames = set( [ tp[0] for tp in sorted_counts[0:MAX_CLASS] ] )

num_features = len(arr)

for entry in entries:

	split = entry.split(',')	
	if len(split) == 1:
		break
	
	name = split[0].split('__')[2]
	
	if name in chosen_classnames:	
		arr = []
		
		for x in range(0, len(split[1]) - KMER_SIZE + 1):	
			gram = split[1][ x : x + KMER_SIZE ]
			arr.append(gram)
			
		arr.append(name)

		assert len(arr) == num_features
	
		print ",".join(arr)