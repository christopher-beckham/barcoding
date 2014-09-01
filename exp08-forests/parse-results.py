import sys
import glob

filenames = glob.glob( sys.argv[1] )

for filename in filenames:
	f = open(filename)
	stratified = False
	for line in f:
		line = line.rstrip()
		if line == "=== Stratified cross-validation ===":
			stratified = True
		else:
			if "Correctly Classified Instances" in line and stratified:
				accuracy = line.split()[4]
				print filename,
				print "==>",
				print accuracy
				break
	f.close()