package wekatest;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.util.Random;
import weka.core.Instances;
import weka.core.converters.ConverterUtils.DataSource;

class SplitTest {

	private static final int NUM_FOLDS = 3;
	
	public static void main(String[] args) throws Exception {
		
		/*
		 * http://weka.wikispaces.com/Generating+cross-validation+folds+(Java+approach)
		 */
		
		String inFile = null;
		String trainFile = null;
		String testFile = null;
		Integer seed = null;
		for(int x = 0; x < args.length; x += 2) {
			String s = args[x];
			if (s.equals("-in")){
				inFile = args[x+1];
			} else if(s.equals("-outtrain")) {
				trainFile = args[x+1];
			} else if(s.equals("-outtest")) {
				testFile = args[x+1];
			} else if(s.equals("-seed")) {
				seed = Integer.parseInt(args[x+1]);
			} else {
				System.err.println("Error - did not recognize argument");
				System.exit(1);
			}
		}

		Random rand = new Random(seed);
		DataSource source = new DataSource(inFile);
		Instances trainData = source.getDataSet();
		trainData.randomize(rand);	
		trainData.setClassIndex( trainData.numAttributes() - 1 );
		
		/*
		 * Folds 1 and 2 will be our training data (66%).
		 * Append fold 2 onto fold 1.
		 */
		
		Instances fold1 = trainData.testCV(NUM_FOLDS, 0);
		Instances fold2 = trainData.testCV(NUM_FOLDS, 1);
		for(int x = 0; x < fold2.numInstances(); x++) {
			fold1.add( fold2.get(x) );
		}
		
		/*
		 * Fold 3 will be our testing data (33%)
		 */
		
		Instances fold3 = trainData.testCV(NUM_FOLDS, 2);
		
		BufferedWriter bw = new BufferedWriter(new FileWriter(trainFile));
		bw.write(fold1.toString());
		bw.flush();
		bw.close();
		
		bw = new BufferedWriter(new FileWriter(testFile));
		bw.write(fold3.toString());
		bw.flush();
		bw.close();
	}

}
