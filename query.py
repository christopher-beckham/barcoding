from Bio import Entrez

Entrez.email = 'cjb60@students.waikato.ac.nz'

import sys
import time

DEBUG = False

nuc_handle = Entrez.esearch(db="nuccore", term="Insecta[ORGN] AND cox1[GENE] NOT genome[title]", retmax=1000)
nuc_records = Entrez.read(nuc_handle)
nuc_ids = nuc_records['IdList'][0:200]

nuc2tax = dict()
for k in range(0, len(nuc_ids), 500):
	link_handle = Entrez.elink( dbfrom="nuccore", db="taxonomy", id=nuc_ids[k:k+500] )
	link_records = Entrez.read(link_handle)
	for elem in link_records:
		if len(elem['LinkSetDb']) > 0:
			assert len(elem['IdList']) == 1
			nuc_id = elem['IdList'][0]

			tax_ids = elem['LinkSetDb'][0]['Link']
			assert len(tax_ids) == 1

			nuc2tax[ nuc_id ] = tax_ids[0]['Id']
		
tax2genus = dict()
for k in range(0, len(nuc_ids), 500):
	genus_handle = Entrez.efetch( db="taxonomy", id=nuc2tax.values()[k:k+500] )
	genus_records = Entrez.read(genus_handle)
	for record in genus_records:
		classes = record['LineageEx']
		for clas in classes:
			if clas['Rank'].lower() == 'family':
				tax2genus[ record['TaxId'] ] = clas['ScientificName']
				
				
"""				
xml_handle = Entrez.efetch( db="nuccore", id=nuc_ids[0], rettype="native", retmode="xml" )
xml_records = Entrez.read(xml_handle)
				
print xml_records
				
				
				
sys.exit(0)
"""
			
# ok, get the FASTA files from the nuc_ids

for k in range(0, len(nuc_ids), 500):
	fasta_handle = Entrez.efetch( db="nuccore", id=nuc_ids[k:k+500], rettype="fasta", retmode="xml" )
	fasta_records = Entrez.read(fasta_handle)

	for elem in fasta_records:
	
		key = elem['TSeq_gi']
		key2 = nuc2tax[key]
		
		fasta_id = "__".join( [ key, key2, tax2genus[key2] ] )
		
		# TODO
		if len( elem['TSeq_sequence'] ) <= 1000:	
			print '>' + fasta_id
			print elem['TSeq_sequence']

if DEBUG:
	for key in nuc2tax:
		print key,
		print "==>",
		key2 = nuc2tax[key]
		print key2,
		print "==>",
		print tax2genus[key2]
	