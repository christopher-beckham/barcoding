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

train: output/res.fasta
	cp -r java-workspace/wekatest/src/wekatest/ wekatest
	javac wekatest/*.java
	python gen-params.py 0,500,100 1,5,1 | parallel --no-notice --colsep ' ' --max-procs=1 --bar './exp.sh {1} {2}'
	
output/res.fasta:
	python 01-query.py --limit=$(EXP01_NUCLIMIT) > output/res.fasta
	
clean:
	find output/* | grep -v "output/res.fasta" | xargs rm
	rm -r wekatest
	
fullclean:
	rm output/*.*
	rm -r wekatest