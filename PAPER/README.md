Supervised DNA barcode classification in WEKA
===

If you haven't already, `cd ..` and run `source env.sh` - this will set up some environment variables that are needed.

To create the ARFF files for iBOL species, run:

```
make -f ibol.make json && make -f ibol.make arff
```

To create the ARFF files for Nucleotide Genus and Nucleotide Family, run:

```
make -f res50k.make json && make -f res50k.make arff
```

Your `output/` folder should now have these files:

```
res50k.family.s1.arff
...
res50k.family.s5.arff

res50k.genus.s1.arff
...
res50k.genus.s5.arff

ibol.s1.arff
...
ibol.s5.arff
```

There's a whole bunch of other stuff in those makefiles like the cross-validation experiments and so forth, but right now if you wanted you could also just load those ARFFs into WEKA and start playing around with them.



