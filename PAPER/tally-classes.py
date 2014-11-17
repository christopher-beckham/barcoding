import sys

print "class"
while True:
	line = sys.stdin.readline().rstrip()
	if line == "@data":
		break
		
for line in sys.stdin:
	line = line.rstrip()
	if line == "":
		continue
	line = line.split(',')
	print line[ len(line)-1 ]