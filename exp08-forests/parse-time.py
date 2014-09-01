import sys
import glob

def mean(arr):
	c = 0.0
	for elem in arr:
		c += elem
	c = c / len(arr)
	return c

filenames = glob.glob( sys.argv[1] )

for filename in filenames:
	f = open(filename)
	print filename,
	print "==>",
	times = []
	for line in f:
		line = line.rstrip().split()
		if len(line) == 2 and line[0] == 'real':
			tm = line[1].split('m')
			mins = float(tm[0])
			secs = float(tm[1].replace('s',''))
			
			times.append((mins*60) + secs)
			print ((mins*60) + secs),
			
	print "==>",
	print mean(times)
		
	f.close()