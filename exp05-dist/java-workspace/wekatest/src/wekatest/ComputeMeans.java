package wekatest;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;

import weka.core.DenseInstance;
import weka.core.Instance;
import weka.core.Instances;
import weka.core.converters.ArffSaver;
import weka.core.converters.ConverterUtils.DataSource;

class ComputeMeans {

	private static final int NUM_FOLDS = 2;
	
	public static void main(String[] args) throws Exception {
		
		/*
		 * http://weka.wikispaces.com/Generating+cross-validation+folds+(Java+approach)
		 */
		
		String inFile = null;
		for(int x = 0; x < args.length; x += 2) {
			String s = args[x];
			if (s.equals("-in")){
				inFile = args[x+1];
			} else {
				System.err.println("Error - did not recognize argument");
				System.exit(1);
			}
		}
		
		Random rand = new Random(0);
		DataSource source = new DataSource(inFile);
		Instances fullData = source.getDataSet();
		fullData.randomize(rand);	
		fullData.setClassIndex( fullData.numAttributes() - 1 );
		
		System.out.println(fullData.classAttribute().numValues() );
		
		Instances trainData = fullData.testCV(NUM_FOLDS, 0);
		Instances testData = fullData.testCV(NUM_FOLDS, 1);
		
		
		ArrayList< ArrayList<Instance> > classMeansMap = 
				new ArrayList< ArrayList<Instance> >( fullData.classAttribute().numValues() );
		for(int x = 0; x < trainData.classAttribute().numValues(); x++) {
			classMeansMap.add( new ArrayList<Instance>() );
		}
		
		// TODO: fix
		for(int x = 0; x < trainData.numInstances(); x++) {
			Instance tmp = trainData.get(x);
			int classIndex = (int) tmp.value( tmp.classAttribute() );
			
			//System.out.print(classIndex + " ==> ");
			//System.out.println( tmp.classAttribute().value( (int) classValue) );

			ArrayList<Instance> list = classMeansMap.get(classIndex);
			list.add(tmp);
		}
		
		
		Instances classMeans = new Instances(trainData, trainData.numClasses());

		/*
		 * For each class value:
		 *   means = {}
		 *   For each attribute
		 *     For each instance of that class value:
		 *       ...
		 *   
		 */
		for(int c = 0; c < classMeansMap.size(); c++) {
			ArrayList<Instance> classInsts = classMeansMap.get(c);
			// for each attribute
			Instance meanInstance = new DenseInstance( trainData.numAttributes() );
			for(int a = 0; a < trainData.numAttributes(); a++) {
				double attrSum = 0;
				for(int i = 0; i < classInsts.size(); i++) {
					attrSum += classInsts.get(i).value(a);
				}
				attrSum = attrSum / classInsts.size();
				meanInstance.setValue(a, attrSum);
			}
			meanInstance.setValue(trainData.classIndex(), c);
			classMeans.add(meanInstance);
		}
		
		ArffSaver saver = new ArffSaver();
		saver.setInstances(classMeans);
		saver.setFile(new File("train.arff"));
		saver.writeBatch();
		
		saver = new ArffSaver();
		saver.setInstances(testData);
		saver.setFile(new File("test.arff"));
		saver.writeBatch();
	}
	

}
