#=== Detailed Accuracy By Class ===

import sys

F_MEASURE = 4
CLASS = 8
metrics = []
class_sizes = []

print "f_measure,class,count"

body = []
for line in sys.stdin:
	body.append( line.rstrip() )

body = body[ body.index("=== Detailed Accuracy By Class ===") + 3 :: ]
for line in body:
	if "Weighted Avg." in line:
		break
	line = line.split()
	if len(line) >= 5:
		metrics.append( [ line[F_MEASURE], '"' + " ".join(line[CLASS::]) + '"' ] )



body = body[ body.index("=== Confusion Matrix ===") + 3 :: ]
for line in body:
	if line == "":
		break
	line = line.split()
	class_sizes.append( [ str(sum([ int(elem) for elem in line[0 : line.index('|') ] ])) ] )
	
for i in range(0, len(metrics)):
	print ",".join( metrics[i] + class_sizes[i] )