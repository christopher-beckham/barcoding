from sys import stdin
import sys

N = 0

body = stdin.read()
body = body.split('\n')
body = body[3:len(body)-2]
final_body = []
do_count = True
for elem in body:
	if '*' not in elem:
		elem = elem.split()
		if len(elem) > 1:
			final_body.append(elem)
			if do_count:
				N += 1
		else:
			do_count = False
	else:
		do_count = False	

		
seqs = dict()
for elem in final_body:
	if elem[0] not in seqs:
		seqs[ elem[0] ] = []
	seqs[ elem[0] ].append( elem[1] )

for key in seqs:
	print key + "," + "".join(seqs[key])