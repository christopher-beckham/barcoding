rm -r wekatest
cp -r java-workspace/wekatest/src/wekatest wekatest
javac wekatest/*.java

java wekatest/ComputeMeans -in $OUT_FOLDER_WIN/res50k.csv.arff -out $OUT_FOLDER_WIN


