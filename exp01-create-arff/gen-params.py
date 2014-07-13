import sys

s1 = [int(x) for x in sys.argv[1].split(',')]
s2 = [int(x) for x in sys.argv[2].split(',')]

for i in range(s1[0], s1[1]+1, s1[2]):
	for j in range(s2[0], s2[1]+1, s2[2]):
		print i,
		print j