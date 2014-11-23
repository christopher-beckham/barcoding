import sys
from Bio import SeqIO
import argparse
import json

parser = argparse.ArgumentParser(description="Summarise the classes from a Porter FASTA file")
parser.add_argument('--infile', dest='infile', required=True, help="FASTA input file")
#parser.add_argument('--taxlevel', dest='taxlevel', required=True, help="Taxonomic level (e.g. genus, family)")
args = parser.parse_args()

"""
">HQ449142 Metazoa;Arthropoda;Insecta;Diptera;Dolichopodidae;Aphrosylus"
kingdom;phylum;class;order;family;genus
"""

family = 4
genus = 5

#classes = dict()

json_arr = []
f = open(args.infile)
num_seqs = 0
for record in SeqIO.parse(f, "fasta"):
	clas = str(record.description)[1::].split()[1].split(';')
	if len(clas) != 6:
		clas.append("?")
	json_arr.append( {"nucid": "?", "taxinfo": {"genus": clas[genus], "family": clas[family]}, "fasta": str(record.seq).upper() } )
	num_seqs += 1
	
f.close()

sys.stderr.write("Number of sequences: " + str(num_seqs) + "\n")

print json.dumps(json_arr, sort_keys=True, indent=4, separators=(',', ': '))

"""
for key in classes:
	print key,
	print classes[key]
	
print len(classes.keys())
"""