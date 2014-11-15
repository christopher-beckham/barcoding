import sys
import glob

filenames = glob.glob( sys.argv[1] )

for filename in filenames:
	f = open(filename)
	stratified = False
	for line in f:
		line = line.rstrip()
		if "=== Stratified cross-validation ===" in line or "=== Error on test data ===" in line:
			stratified = True
		else:
			if "Correctly Classified Instances" in line and stratified:
				accuracy = line.split()[4]
				print filename + "," + accuracy
				break
	f.close()