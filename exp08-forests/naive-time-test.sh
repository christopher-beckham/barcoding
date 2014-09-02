#!/bin/bash

java -Xmx6000M weka.filters.supervised.instance.StratifiedRemoveFolds -S 0 -N 10 -F 1 -c last -i output/res50k.genus.s1.arff > output/res50k.tmp.arff

# naive bayes assuming a normal distribution

echo > results/naive-time-test.sh

########################
# Naive Bayes training #
########################

echo >> results/naive-time-test.sh
echo "Naive Bayes by default\n" >> results/naive-time-test.sh

{ time java -Xmx6000M weka.classifiers.bayes.NaiveBayes -t output/res50k.tmp.arff -no-predictions -c last -d output/tmp1.model -no-cv -o -v > /dev/null; } 2>> results/naive-time-test.sh

echo >> results/naive-time-test.sh
echo "Naive Bayes using a kernel density estimator\n" >> results/naive-time-test.sh

{ time java -Xmx6000M weka.classifiers.bayes.NaiveBayes -K -t output/res50k.tmp.arff -no-predictions -c last -d output/tmp2.model -no-cv -o -v > /dev/null; } 2>> results/naive-time-test.sh

echo >> results/naive-time-test.sh
echo "Naive Bayes with supervised discretisation\n" >> results/naive-time-test.sh

{ time java -Xmx6000M weka.classifiers.bayes.NaiveBayes -D -t output/res50k.tmp.arff -no-predictions -c last -d output/tmp3.model -no-cv -o -v > /dev/null; } 2>> results/naive-time-test.sh

#######################
# Naive Bayes testing #
#######################

echo >> results/naive-time-test.sh
echo "Naive Bayes testing default" >> results/naive-time-test.sh

{ time java -Xmx6000M weka.classifiers.bayes.NaiveBayes -l output/tmp1.model -T output/res50k.tmp.arff > /dev/null; } 2>> results/naive-time-test.sh

echo >> results/naive-time-test.sh
echo "Naive Bayes testing KDE" >> results/naive-time-test.sh

{ time java -Xmx6000M weka.classifiers.bayes.NaiveBayes -l output/tmp2.model -T output/res50k.tmp.arff > /dev/null; } 2>> results/naive-time-test.sh

echo >> results/naive-time-test.sh
echo "Naive Bayes testing supervised discretisation" >> results/naive-time-test.sh

{ time java -Xmx6000M weka.classifiers.bayes.NaiveBayes -l output/tmp3.model -T output/res50k.tmp.arff > /dev/null; } 2>> results/naive-time-test.sh

#rm output/tmp1.model
#rm output/tmp2.model
#rm output/tmp3.model



