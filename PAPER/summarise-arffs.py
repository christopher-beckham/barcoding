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
	for line in f:
		line = line.rstrip().split(',')
		if first_time:
			vec['features'] = len(line) - 1
			first_time = False
		else:
			classnames.add( line[ len(line) - 1] )
	vec['classes'] = len(classnames)
	f.close()
	print vec