import sys

f = open(sys.argv[1])
f.readline()
hm = dict()
for line in f:
	line = line.rstrip().split(',')
	idx = len(line) - 1
	if line[idx] not in hm:
		hm[ line[idx] ] = 1
	else:
		hm[ line[idx] ] += 1
		
f.close()

print "class,count"

for key in hm:
	print key + "," + str(hm[key])