import sys

for line in sys.stdin:
	line = line.rstrip().split()
	if len(line) == 2 and line[0] == 'real':
		tm = line[1].split('m')
		mins = float(tm[0])
		secs = float(tm[1].replace('s',''))
		
		print ((mins*60) + secs),
		print "secs"