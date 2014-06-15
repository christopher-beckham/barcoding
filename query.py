from Bio import Entrez

Entrez.email = 'cjb60@students.waikato.ac.nz'

# http://biopython.org/DIST/docs/tutorial/Tutorial.html#sec125
# Section 9.15.1 -- Searching for and DL using history
# 346447553

# Insecta[ORGN] AND family[RANK]

import sys
import time

"""
Ok, what we want to do is map each Taxonomy entry to Nucleotide entries. E.g:
9001 ==> 243535, 346364, 43643
9002 ==> 124433
etc.
"""

t_handle = Entrez.esearch(db="taxonomy", term="Insecta[ORGN] AND genus[RANK]", retmax=100000)
t_records = Entrez.read(t_handle)
t_records_idlist = t_records['IdList']

t_name_handle = Entrez.efetch(db="taxonomy", id=t_records_idlist)
t_name_records = Entrez.read(t_name_handle)

for i in range(0,len(t_name_records)):
	print t_name_records[i]['ScientificName']

sys.exit(0)



sys.exit(0)

saved_nuc_ids = []

for k in range(0, len(t_records_idlist), 500):
	t2n_handle = Entrez.elink(dbfrom="taxonomy", db="nuccore", id=t_records_idlist[k:k+500])
	t2n_records = Entrez.read(t2n_handle)

	for elem in t2n_records:
		if len(elem['LinkSetDb']) > 0:
			tax_id = elem['IdList']
			print str(tax_id) + " ==>",

			nuc_ids = elem['LinkSetDb'][0]['Link']
			for nuc_id in nuc_ids:
				saved_nuc_ids.append( nuc_id )
				print nuc_id['Id'],
			print

sys.exit(0)

n_handle = Entrez.esearch(db="nuccore", term="(cox1[gene] OR coxI[gene] OR CO1[gene] OR COI[gene])", retmax=2000, id=saved_nuc_ids[0:5])
n_records = Entrez.read(n_handle)

print
print
print n_records

#for elem in g_records[0]['LinkSetDb'][0]['Link']:
#	print elem


#gg_handle = Entrez.esearch(db="gene", term="(cox1[gene] OR coxI[gene] OR CO1[gene] OR COI[gene]) AND #1", retmax=2000, webenv=t_records_webenv, querykey=t_records_querykey, id=t_records_idlist)
#print Entrez.read(gg_handle)


#handle2 = Entrez.esearch(db="gene", term="COX", id=recs[1:100])

# cox1[gene] OR coxI[gene] OR CO1[gene] OR COI[gene]