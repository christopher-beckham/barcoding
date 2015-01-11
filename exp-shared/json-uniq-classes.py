import sys
import json

js = json.loads( sys.stdin.read() )
taxlevel = sys.argv[1]

s = set()
for rec in js:
	s.add(rec['taxinfo'][taxlevel])

print "# of unique class values: ",
print len(s)

print "# records: ",
print len(js)