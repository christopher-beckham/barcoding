package wekatest;

import java.text.DecimalFormat;
import java.util.Random;

import weka.core.Attribute;
import weka.core.Instances;
import weka.core.converters.ConverterUtils.DataSource;
import weka.classifiers.Classifier;
import weka.classifiers.Evaluation;
import weka.classifiers.bayes.NaiveBayes;

class NaiveBayesTest {
	
	public static void main(String[] args) throws Exception {
		
		Classifier classifier = (Classifier) new NaiveBayes();
		DataSource src = new DataSource( args[0] );
		Instances trainingSet = src.getDataSet();
		trainingSet.setClassIndex( trainingSet.numAttributes() - 1);
		
		//classifier.buildClassifier(trainingSet);
		
		Evaluation xVal = new Evaluation(trainingSet);
		xVal.crossValidateModel(classifier, trainingSet, 3, new Random(0) );
		
		//System.out.println( xVal.recall(0) );
		
		// testing
		//System.out.println( trainingSet.numClasses() );
		
		Attribute classAttr = trainingSet.attribute( trainingSet.classIndex() );
		DecimalFormat df = new DecimalFormat("#.##");
		System.out.println("class,recall,accuracy");
		for(int x = 0; x < trainingSet.numClasses(); x++) {
			System.out.print( classAttr.value(x) + "," );
			System.out.print( df.format( xVal.recall(x) ) + "," );
			//System.out.println( df.format( xVal.precision(x) ) );
			System.out.println( df.format( xVal.pctCorrect() ) );
		}
	}

}
