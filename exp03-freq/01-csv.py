from Bio import SeqIO
from Bio import Seq

import sys
import StringIO
import operator


contents = sys.stdin.read()

globals = set()
KMER_SIZE = 4

"""
There will likely be a lot of classes, so let's put a limit on them,
defined by MAX_CLASS. Only choose the most common classes, from 0 to
MAX_CLASS.
"""
MAX_CLASS = 40
class_counts = dict()

fstring = StringIO.StringIO(contents)
records = SeqIO.parse(fstring, "fasta")
for rec in records:
	for x in range(0, len(rec.seq) - KMER_SIZE + 1):
		kmer = str(rec.seq[x:x+KMER_SIZE])
		if kmer not in globals:
			globals.add(kmer)
	classname = rec.id.split('__')[2]
	if classname not in class_counts:
		class_counts[classname] = 1
	else:
		class_counts[classname] += 1
		
sorted_counts = sorted(class_counts.iteritems(), key=operator.itemgetter(1), reverse=True)
chosen_classnames = set( [ tp[0] for tp in sorted_counts[0:MAX_CLASS] ] )

labels = []			
for glob in globals:
	labels.append(glob + "_f")
labels.append("class")
print ",".join(labels)

records.close()

fstring = StringIO.StringIO(contents)
records = SeqIO.parse(fstring, "fasta")
for rec in records:
	classname = rec.id.split('__')[2]
	if classname in chosen_classnames:
		hm = dict()
		for x in range(0, len(rec.seq) - KMER_SIZE + 1):
			kmer = str(rec.seq[x:x+KMER_SIZE])
			if kmer not in hm:
				hm[kmer] = 1
			else:
				hm[kmer] += 1
		vector = []
		for glob in globals:
			if glob not in hm:
				vector.append('0')
			else:
				vector.append( str( float(hm[glob]) / float( len(rec.seq) - KMER_SIZE )) )
				#vector.append( str(float(hm[glob])))
		vector.append( classname )
		print ",".join(vector)
	
records.close()