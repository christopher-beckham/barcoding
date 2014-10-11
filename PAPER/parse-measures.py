#=== Detailed Accuracy By Class ===

import sys

F_MEASURE = 4 # the index of the f-measure column
CLASS = 8
metrics = []
class_sizes = []

body = []
for line in sys.stdin:
	body.append( line.rstrip() )

print "f_measure,class,count"	
	
body = body[ body.index("=== Detailed Accuracy By Class ===") + 3 :: ]
for line in body:
	if "Weighted Avg." in line:
		line = line.split()
		metrics.append( [ line[F_MEASURE+2], '"WEIGHTED F-MEASURE"' ] )
		break
	else:
		line = line.split()
		if len(line) >= 5:
			metrics.append( [ line[F_MEASURE], '"' + " ".join(line[CLASS::]) + '"' ] )


body = body[ body.index("=== Confusion Matrix ===") + 3 :: ]
for line in body:
	if line == "":
		break
	line = line.split()
	class_sizes.append( [ str(sum([ int(elem) for elem in line[0 : line.index('|') ] ])) ] )
class_sizes.append(["0"])
	
for i in range(0, len(metrics)):
	print ",".join( metrics[i] + class_sizes[i] )