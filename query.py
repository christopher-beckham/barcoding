from Bio import Entrez

Entrez.email = 'cjb60@students.waikato.ac.nz'

# http://biopython.org/DIST/docs/tutorial/Tutorial.html#sec125
# Section 9.15.1 -- Searching for and DL using history
# 346447553

# Insecta[ORGN] AND family[RANK]

import sys
import time


t_handle = Entrez.esearch(db="taxonomy", term="Insecta[ORGN] AND genus[RANK]", retmax=100000)
t_records = Entrez.read(t_handle)
t_records_idlist = t_records['IdList']


"""
t2n maps from tax ids to nuccore ids
e.g. t2n[6091] = [24232, 53252, ..., 436436]
"""
t2n = dict()
nuccore_ids = []
for k in range(0, len(t_records_idlist), 500):
	t2n_handle = Entrez.elink(dbfrom="taxonomy", db="nuccore", id=t_records_idlist[k:k+500])
	t2n_records = Entrez.read(t2n_handle)
	for elem in t2n_records:
		if len(elem['LinkSetDb']) > 0:
			tax_id = elem['IdList'][0]
			if tax_id not in t2n:
				t2n[tax_id] = []
			nuc_ids = elem['LinkSetDb'][0]['Link']
			for nuc_id in nuc_ids:
				t2n[tax_id].append(nuc_id)
				nuccore_ids.append(nuc_id)


n2n_handle = Entrez.elink(dbfrom="nuccore", db="nuccore", term="cox1[gene] OR coxI[gene] OR CO1[gene] OR COI[gene]", id=nuccore_ids[0:100])
n2n_records = Entrez.read(n2n_handle)

print n2n_records


"""
Entrez query used to limit the output set of linked UIDs. 
The query in the term parameter will be applied after the link operation,
and only those UIDs matching the query will be returned by ELink.
The term parameter only functions when db and dbfrom are set to the same database value.
"""

"""
n_handle = Entrez.esearch(db="nuccore", term="(cox1[gene] OR coxI[gene] OR CO1[gene] OR COI[gene])", retmax=2000, id=saved_nuc_ids[0:100])
n_records = Entrez.read(n_handle)


print
print
print n_records

#for elem in g_records[0]['LinkSetDb'][0]['Link']:
#	print elem


#gg_handle = Entrez.esearch(db="gene", term="(cox1[gene] OR coxI[gene] OR CO1[gene] OR COI[gene]) AND #1", retmax=2000, webenv=t_records_webenv, querykey=t_records_querykey, id=t_records_idlist)
#print Entrez.read(gg_handle)


#handle2 = Entrez.esearch(db="gene", term="COX", id=recs[1:100])

"""

# cox1[gene] OR coxI[gene] OR CO1[gene] OR COI[gene]