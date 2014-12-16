import sys
import glob

header = \
[
"\\begin{table}[h!]",
"\caption{Summary information for each ARFF file.}",
"\\begin{tabular}{cccc}",
"\hline",
"& \# instances & \# features & \# classes \\\\ ",
"\hline"
]

footer = \
[
"\hline",
"\end{tabular}",
"\end{table}"
]

filenames = glob.glob( sys.argv[1] )

print "\n".join(header)

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
	print filename + " & " + str(vec['instances']) + " & " + str(vec['features']) + " & " + str(vec['classes']) + " \\\\"

print "\n".join(footer)