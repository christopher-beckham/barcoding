from Bio import SeqIO
from Bio import Seq

import sys
import StringIO

"""
TODO: read from stdin instead?
"""

fstring = StringIO.StringIO( sys.stdin.read() )

records = SeqIO.parse(fstring, "fasta")
for rec in records:
	print rec.id + "," + rec.seq