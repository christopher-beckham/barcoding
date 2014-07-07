# -------------------------------------------------
# http://www.gnu.org/software/make/manual/make.html
# -------------------------------------------------

# "If you write a rule whose recipe will not create the target file,
# the recipe will be executed every time the target comes up for remaking".
# -- So if we don't phony "train", it will think it's a file that doesn't exist,
#    and will end up trying to "make" it.
.PHONY : train clean fullclean


train: output/res.fasta
	cp -r java-workspace/wekatest/src/wekatest/ wekatest
	javac wekatest/*.java
	./exp.sh
	
output/res.fasta:
	python 01-query.py --limit=$(EXP01_NUCLIMIT) > output/res.fasta
	
clean:
	find output/* | grep -v "output/res.fasta" | xargs rm
	rm -r wekatest
	
fullclean:
	rm output/*.*
	rm -r wekatest