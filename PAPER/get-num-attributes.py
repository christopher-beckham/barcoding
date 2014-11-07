import sys

attr_count = 0
while True:
	line = sys.stdin.readline()
	if "@attribute" in line:
		attr_count += 1
	else:
		if "@data" in line:
			break
		
print attr_count - 1