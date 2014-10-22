# family

python $EXP_SHARED/filter-json.py --maxclass=c20 --taxlevel=family --minlen=300 < $OUT_FOLDER/res50k.json.pre > test/res50k.family.json
python $EXP_SHARED/chop-json.py --fraglen=300 --maxfrags=5 --seed=1 < output/res50k.family.json > test/res50k.family.s1.json
python $EXP_SHARED/json2arff.py --outtrain=test/res50k.family.s1.arff --intrain=test/res50k.family.s1.json --kmerrange=3,5 --taxlevel=family --maxclass=m100000


java -Xmx6000M weka.filters.supervised.instance.SpreadSubsample -M 0.0 -X 300.0 -S 1 -c last < test/res50k.family.s1.arff > test/res50k.family.s1.small.arff

java -server -Xmx7000M weka.classifiers.meta.AttributeSelectedClassifier -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T 0.5 -N -1" -W weka.classifiers.trees.RandomForest -t test/res50k.family.s1.small.binary.arff -no-predictions -c last -x 3 -v -o -- -I 30 -K 0 -S 1 -num-slots 4 > test/result.txt

# weka.classifiers.meta.AttributeSelectedClassifier -E "weka.attributeSelection.InfoGainAttributeEval " -S "weka.attributeSelection.Ranker -T -1.7976931348623157E308 -N 1000" -W weka.classifiers.trees.RandomForest -- -I 30 -K 0 -S 1 -num-slots 4