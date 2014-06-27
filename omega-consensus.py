from Bio import SeqIO
from Bio import Seq

import sys

"""
TODO: read from stdin instead?
"""

omega_file = sys.argv[1]

records = SeqIO.parse(open(omega_file), "fasta")
for rec in records:
	print rec.id + "," + rec.seq