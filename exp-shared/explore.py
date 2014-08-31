import json
import sys

js = json.loads( open(sys.argv[1]).read() )
classes = dict()


print_classes = False

if print_classes:
    for rec in js:
        if rec['taxinfo']['species'] not in classes:
            classes[ rec['taxinfo']['species'] ] = 1
        else:
            classes[ rec['taxinfo']['species'] ] += 1

        for key in classes:
            if classes[key] >= 20:
                print key,
                print classes[key]

i = 0
for rec in js:
    i += 1
    if rec['taxinfo']['species'] == "Diptera sp. BOLD:AAB0377":
        print '>' + str(i)
        print rec['fasta']
