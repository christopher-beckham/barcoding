Overview
===

One reason why Porter et. al decided to pursue a Naive Bayes classifier was because BLAST-based methods were too slow in classification. In this experiment I wanted
to compare the classification speed of the Naive Bayes classifiers I produced in an earlier experiment and BLAST. In order to use BLAST as a classifier, I created
a local BLAST database (using `makeblastdb`) using the FASTA file of sequences which was used to derive the ARFF files for the Naive Bayes classifiers.

Experiment
===

1. BLAST
---

Create a local BLAST database from the FASTA file, and then BLAST every sequence in that same FASTA file:

```
blastn -db $OUT_FOLDER_WIN/res50k.fasta -query $OUT_FOLDER_WIN/res50k.fasta -outfmt 10 -num_threads 4 -num_alignments 1
```

Time taken:

```
real	17m0.369s
```

2. Naive Bayes
---

Train a Naive Bayes classifier with the following scheme:

```
Scheme:       weka.classifiers.bayes.NaiveBayes -D
Relation:     res50k
Instances:    36683
Attributes:   3919
```

Then time the prediction on the same training set:

```
real	15m31.466s
```

3. Naive Bayes (with the best 500 attributes according to information gain ranking)
---

Train a Naive Bayes classifier with the following scheme:

```
Scheme:       weka.classifiers.meta.AttributeSelectedClassifier -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.0 -N 500" -W weka.classifiers.bayes.NaiveBayes -- -D
Relation:     res50k
Instances:    36683
Attributes:   3919
```

Then time the prediction on the same training set:

```
real	2m44.748s
```

Conclusion
===

From the experiments, it appears that Naive Bayes is only ~ 2 minutes faster than BLAST when predicting on ~ 40,000 sequences.
When we run Naive Bayes with information gain however (only retaining the 500 best attributes) it only takes ~ 3 minutes
to predict on the training set. This experiment has shown that it is really important (at least in the case of Naive Bayes) to
use attribute selection, otherwise it may be just as slow as using BLAST which is not ideal.

It may be possible to speed up BLAST itself by playing around with its parameters (so that we trade off accuracy for speed),
and I may undertake this in a future experiment.

In future however, it would be more accurate to time the experiments using user+sys time rather than real time (as real time
can be affected by other processes running).

