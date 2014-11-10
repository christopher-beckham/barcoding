import json
import sys

js = json.loads( open(sys.argv[1]).read() )
taxlevel = sys.argv[2]
classname = sys.argv[3]

i = 0
for rec in js:
    if rec['taxinfo'][taxlevel] == classname:
        print '>' + classname.replace(" ", "_") + "_seq" + str(i)
        print rec['fasta']
        i += 1
