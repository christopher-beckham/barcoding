import sys

cols_to_retain = 5
cols = ["dataset", "nb", "rf", "nbd", "rfd"]

instances = []

for line in sys.stdin:
	line = line.rstrip()
	line = line.split(',')
	line = [x for x in line if x not in ["*", "' '", "v"] ]
	line = line[0:cols_to_retain]
	instances.append(line)

new_instances = sorted(instances, key=lambda x: x[0])

print ",".join(cols)
for x in new_instances:
	print ",".join(x)