import sys
import glob

filenames = glob.glob( sys.argv[1] )
num_instances = sys.argv[2]


print "filename, avg_time, time_per_query"

for filename in filenames:
	f = open(filename)
	print filename + ",",
	#print "==>",
	times = []
	for line in f:
		line = line.rstrip().split()
		if len(line) == 2 and line[0] == 'real':
			tm = line[1].split('m')
			mins = float(tm[0])
			secs = float(tm[1].replace('s',''))
			
			times.append((mins*60) + secs)
			#print ((mins*60) + secs),
			
	#print "==>",
	avg = sum(times) / len(times)
	print ("%.4f" % avg) + ",",
	print ("%.4f" % (avg / num_instances))
		
	f.close()