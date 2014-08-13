#!/bin/bash

# make the blast database
makeblastdb -in $OUT_FOLDER_WIN/res50k.fasta -parse_seqids -dbtype nucl

# time the classification of all sequences in res50k.fasta 
{ time blastn -db $OUT_FOLDER_WIN/res50k.fasta -query $OUT_FOLDER_WIN/res50k.fasta -outfmt 10 -num_threads 4 -num_alignments 1 ; } 2> results/blast-time.txt

# time weka's classification of res50k.csv.arff
java -Xmx6000M weka.classifiers.bayes.NaiveBayes -D -t $OUT_FOLDER_WIN/res50k.csv.arff -no-cv -v -o -d naive.model.tmp
{ time java -Xmx6000M weka.classifiers.bayes.NaiveBayes -l naive.model.tmp -T $OUT_FOLDER_WIN/res50k.csv.arff ; } 2> results/naived-time.txt
rm naive.model.tmp

# time weka's classification of res50k.csv.arff with info gain @ 500
java -Xmx6000M weka.classifiers.meta.AttributeSelectedClassifier -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N 500" -W weka.classifiers.bayes.NaiveBayes -t $OUT_FOLDER_WIN/res50k.csv.arff -no-cv -v -o -d naive.model.tmp -- -D
{ time java -Xmx6000M weka.classifiers.bayes.NaiveBayes -l naive.model.tmp -T $OUT_FOLDER_WIN/res50k.csv.arff ; } 2> results/naived-ig500-time.txt
rm naive.model.tmp

