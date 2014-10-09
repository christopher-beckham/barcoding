import json
import sys

js = json.loads( open(sys.argv[1]).read() )

classname = "Diptera sp. BOLD:ACM4716"

i = 0
for rec in js:
    if rec['taxinfo']['species'] == classname:
        print '>' + classname.replace(" ", "_") + "_seq" + str(i)
        print rec['fasta']
        i += 1
