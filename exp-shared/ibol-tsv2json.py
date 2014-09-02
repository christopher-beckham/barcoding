import sys
import json
import argparse

#parser = argparse.ArgumentParser(description="Convert iBOL TSV file to JSON")
#parser.add_argument('--taxlevel', dest='taxlevel', required=True, help='Taxonomy level (i.e. genus, family, etc.)')
#args = parser.parse_args()

header = sys.stdin.readline().split('\t')

genus = header.index("genus_reg")
order = header.index("order_reg")
family = header.index("family_reg")
species = header.index("species_reg")
nucraw = header.index("nucraw")

json_arr = []

for line in sys.stdin:
    line = line.rstrip().split('\t')
    json_arr.append( { 'nucid': 0, 'taxinfo': {'genus': line[genus], 'order': line[order], 'family': line[family], 'species': line[species]}, 'fasta': line[nucraw] } )

print json.dumps(json_arr)
