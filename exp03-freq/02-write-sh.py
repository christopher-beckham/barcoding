import sys

"""
weka.classifiers.meta.FilteredClassifier -F "weka.filters.unsupervised.attribute.Discretize -B 10 -M -1.0 -R first-last" -W weka.classifiers.meta.Vote -- -S 1 -B "weka.classifiers.meta.FilteredClassifier -F \"weka.filters.unsupervised.attribute.Remove -V -R xxxx-yyyy\" -W weka.classifiers.bayes.NaiveBayes" -R MAJ
"""

"""
inside weka:

weka.classifiers.meta.FilteredClassifier -F "weka.filters.unsupervised.attribute.Discretize -B 10 -M -1.0 -R first-last" -W weka.classifiers.meta.Vote -- -S 1 -B "weka.classifiers.meta.FilteredClassifier -F \"weka.filters.unsupervised.attribute.Remove -V -R 200-300\" -W weka.classifiers.bayes.NaiveBayes" -R MAX
"""

cmd_prefix = [
"java -Xmx6000M",
'weka.classifiers.meta.FilteredClassifier -F "weka.filters.unsupervised.attribute.Discretize -B 10 -M -1.0 -R first-last" -W weka.classifiers.meta.Vote -- -S 1'
]

cmd_mid = []

cmd_postfix = [
"-R MAX"
]

cmd_postpostfix = [
"-t $1 -d $1.model"
]

meta_template = '-B "weka.classifiers.meta.FilteredClassifier -F \\"weka.filters.unsupervised.attribute.Remove -V -R xxxx-yyyy,last\\" -W weka.classifiers.bayes.NaiveBayes"'

for line in sys.stdin:
	idxs = line.rstrip().split(',')[0:2]
	cmd_mid.append( meta_template.replace('xxxx', idxs[0]).replace('yyyy', idxs[1]) )
	
print "#!/bin/bash"
print " ".join(cmd_prefix + cmd_mid + cmd_postfix + cmd_postpostfix)