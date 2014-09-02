#=== Detailed Accuracy By Class ===

import sys

while True:
	line = sys.stdin.readline().rstrip()
	if line == "=== Detailed Accuracy By Class ===":
		break
		
[sys.stdin.readline() for x in range(0,2)]

print "f_measure"
		
for line in sys.stdin:
	line = line.rstrip()
	if "Weighted Avg." in line:
		break
	line = line.split()
	if len(line) >= 5:
		print line[4]