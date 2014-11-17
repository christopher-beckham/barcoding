from Bio import SeqIO
import argparse
import json

parser = argparse.ArgumentParser(description="Create kmer freq csv from res.fasta")
parser.add_argument('--infile', dest='infile', required=True, help="FASTA input file")
args = parser.parse_args()

json_arr = []

f = open(args.infile)
for record in SeqIO.parse(f, "fasta"):
	seq = str(record.seq).replace('-','')
	classname = str(record.id).split('|')[1]
	json_arr.append( {"nucid": seq, "taxinfo": {"species": classname}, "fasta": seq } )
f.close()

print json.dumps(json_arr, sort_keys=True, indent=4, separators=(',', ': '))
