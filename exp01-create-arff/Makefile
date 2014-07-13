# -------------------------------------------------
# http://www.gnu.org/software/make/manual/make.html
# -------------------------------------------------

# "If you write a rule whose recipe will not create the target file,
# the recipe will be executed every time the target comes up for remaking".
# -- So if we don't phony "train", it will think it's a file that doesn't exist,
#    and will end up trying to "make" it.
.PHONY : train clean fullclean

# ./seq.py 0,500,100 1,10,1 | parallel './exp.sh {1} {2}' --threads 4
# python gen-params.py 0,500,100 1,10,1 | parallel --colsep ' ' 'echo {1} {2}'


#python gen-params.py 0,500,100 1,5,1 | parallel --no-notice --colsep ' ' --max-procs=1 --bar './exp.sh {1} {2}'
#python gen-params.py 0,500,100 0,0,1 | parallel --no-notice --colsep ' ' --max-procs=1 --bar './plot.sh {1}'

train: $(OUT_FOLDER)/res.fasta
	cp -r java-workspace/wekatest/src/wekatest/ wekatest
	javac wekatest/*.java
	java wekatest/RecallTest 0,500,100 1,5,1 $(OUT_FOLDER)
	java wekatest/AccuracyTest 0,500,100 1,5,1 $(OUT_FOLDER)
	
$(OUT_FOLDER)/res.fasta:
	python 01-query.py --limit=$(EXP01_NUCLIMIT) > output/res.fasta
	
clean:
	find output/* | grep -v "output/res.fasta" | xargs rm
	rm -r wekatest
	
fullclean:
	rm output/*.*
	rm -r wekatest