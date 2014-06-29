from Bio import SeqIO
from Bio import Seq

import sys
import StringIO

"""
TODO: read from stdin instead?
"""

fstring = StringIO.StringIO( sys.stdin.read() )

first_time = True
seqlen = 0

records = SeqIO.parse(fstring, "fasta")
for rec in records:
	if first_time:
		seqlen = len(rec.seq)
		first_time = False
	assert seqlen == len(rec.seq)
	print rec.id + "," + rec.seq