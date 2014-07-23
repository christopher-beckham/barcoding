package wekatest;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.Random;

import weka.core.Attribute;
import weka.core.Instances;
import weka.core.converters.ConverterUtils.DataSource;
import weka.classifiers.Classifier;
import weka.classifiers.Evaluation;
import weka.classifiers.bayes.NaiveBayes;

class SplitTest {
	
	public static void main(String[] args) throws Exception {
		
		/*
		 * http://weka.wikispaces.com/Generating+cross-validation+folds+(Java+approach)
		 */

		String trainFile = "G:/barcoding/output/kmer.3.csv";
		Random rand = new Random(0);
		
		DataSource source = new DataSource(trainFile);
		Instances trainData = source.getDataSet();
		trainData.randomize(rand);
		
		trainData.setClassIndex( trainData.numAttributes() - 1 );
		//trainData.stratify(3); // cut up into 3 folds
		
		System.out.println( trainData.numInstances() );
		
		/*
		 * Folds 1 and 2 will be our training data (66%)
		 */
		
		Instances fold1 = trainData.testCV(3, 0);
		System.out.println( fold1.numInstances() );
		
		Instances fold2 = trainData.testCV(3, 1);
		System.out.println( fold2.numInstances() );
		
		/*
		 * Fold 3 will be our testing data (33%)
		 */
		
		Instances fold3 = trainData.testCV(3, 2);
		System.out.println( fold3.numInstances() );
		
		for(int x = 0; x < fold2.numInstances(); x++) {
			fold1.add( fold2.get(x) );
		}
		
		System.out.println(fold1.numInstances());
		
		BufferedWriter bw = new BufferedWriter(new FileWriter("training.arff"));
		bw.write(fold1.toString());
		bw.flush();
		bw.close();
		
		bw = new BufferedWriter(new FileWriter("test.arff"));
		bw.write(fold3.toString());
		bw.flush();
		bw.close();
	}

}
