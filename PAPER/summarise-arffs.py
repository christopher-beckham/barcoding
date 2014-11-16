import sys
import glob

filenames = glob.glob( sys.argv[1] )

for filename in filenames:
	classnames = set()
	vec = {'filename': filename}
	f = open(filename)
	while True:
		line = f.readline().rstrip()
		if line == "@data":
			break
	first_time = True
	num_instances = 0
	for line in f:
		line = line.rstrip()
		if line == "":
			continue
		line = line.split(',')
		if first_time:
			vec['features'] = len(line) - 1
			first_time = False
		else:
			classnames.add( line[ len(line) - 1] )
		num_instances += 1
	vec['classes'] = len(classnames)
	vec['instances'] = num_instances
	f.close()
	print vec