import sys
import random
import argparse

random.seed(1)

parser = argparse.ArgumentParser(description='Shuffles an ARFF file and does a 50-50 split of it')
parser.add_argument('--train', dest='train', required=True, help='Output training ARFF')
parser.add_argument('--test', dest='test', required=True, help='Output testing ARFF')
args = parser.parse_args()

header = []

for line in sys.stdin:
	line = line.rstrip()
	header.append(line)
	if line == "@data":
		break

body = []
for line in sys.stdin:
	line = line.rstrip()
	body.append(line)

random.shuffle(body)
training = body[ 0 : len(body)/2 ]
testing = body[ len(body)/2 :: ]

training = header + training
testing = header + testing

f = open(args.train, "wb")
for line in training:
	f.write(line + "\n")
f.close()

f = open(args.test, "wb")
for line in testing:
	f.write(line + "\n")
f.close()