package wekatest;

import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.Random;

import weka.core.Attribute;
import weka.core.Instances;
import weka.core.converters.ConverterUtils.DataSource;
import weka.classifiers.Classifier;
import weka.classifiers.Evaluation;
import weka.classifiers.bayes.NaiveBayes;

class AccuracyTest {
	
	private static String classifyAccuracy(String filename, StringBuilder sb) throws Exception {

		Classifier classifier = (Classifier) new NaiveBayes();
		DataSource src = new DataSource( filename );
		Instances trainingSet = src.getDataSet();
		trainingSet.setClassIndex( trainingSet.numAttributes() - 1);

		Evaluation xVal = new Evaluation(trainingSet);
		xVal.crossValidateModel(classifier, trainingSet, 3, new Random(0) );
		
		sb.append( xVal.correct() );
		sb.append("\n");
		
		return sb.toString();
	}
	
	public static void main(String[] args) throws Exception {

		String[] queryLens = args[0].split(",");
		String[] sampleNums = args[1].split(",");
		String outDir = args[2];
		
		StringBuilder sb = new StringBuilder();
		sb.append("len,accuracy");
		sb.append("\n");
		
		for( int f = Integer.parseInt(queryLens[0]);
				f <= Integer.parseInt(queryLens[1]);
				f += Integer.parseInt(queryLens[2]) ) {
			
			for(int i = Integer.parseInt(sampleNums[0]);
					i <= Integer.parseInt(sampleNums[1]);
					i += Integer.parseInt(sampleNums[2])) {
				
				sb.append(f + ",");
				
				classifyAccuracy(outDir + "/" + "res." + f + "." + i + ".arff", sb);
			}
			
		}
		
		PrintWriter pw = new PrintWriter(outDir + "/" + "accuracy.txt");
		pw.write(sb.toString());
		pw.flush();
		pw.close();
		
	}

}
