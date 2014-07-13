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

class RecallTest {
	
	private static String classifyRecall(String filename, StringBuilder sb) throws Exception {

		Classifier classifier = (Classifier) new NaiveBayes();
		DataSource src = new DataSource( filename );
		Instances trainingSet = src.getDataSet();
		trainingSet.setClassIndex( trainingSet.numAttributes() - 1);

		Evaluation xVal = new Evaluation(trainingSet);
		xVal.crossValidateModel(classifier, trainingSet, 3, new Random(0) );
		
		Attribute classAttr = trainingSet.attribute( trainingSet.classIndex() );
		DecimalFormat df = new DecimalFormat("#.##");
		for(int x = 0; x < trainingSet.numClasses(); x++) {
			sb.append( classAttr.value(x) + "," );
			sb.append( df.format( xVal.recall(x) ) );
			sb.append("\n");
		}
		
		return sb.toString();
	}
	
	public static void main(String[] args) throws Exception {

		String[] queryLens = args[0].split(",");
		String[] sampleNums = args[1].split(",");
		String outDir = args[2];
		
		for( int f = Integer.parseInt(queryLens[0]);
				f <= Integer.parseInt(queryLens[1]);
				f += Integer.parseInt(queryLens[2]) ) {
			
			StringBuilder sb = new StringBuilder();
			sb.append("class,recall");
			sb.append("\n");
			
			for(int i = Integer.parseInt(sampleNums[0]);
					i <= Integer.parseInt(sampleNums[1]);
					i += Integer.parseInt(sampleNums[2])) {
				

				classifyRecall(outDir + "/" + "res." + f + "." + i + ".arff", sb);
			}
			
			PrintWriter pw = new PrintWriter(outDir + "/" + "recall." + f + ".txt");
			pw.write(sb.toString());
			pw.flush();
			pw.close();
			
		}
		
	}

}
