par(mfrow=c(2,3))

files = c("ibol.nb.s1", "ibol.rf.s1", "res50k.genus.nb.s1", "res50k.genus.rf.s1", "res50k.family.nb.s1", "res50k.family.rf.s1")
for(file in files) {
  df = read.csv(paste("f-measures/",file,".fmeasure",sep=""))
  hist(df$f_measure, breaks=20, xlab="F-Measure", main=paste(gsub("res50k", "nucleotide", gsub(".s1", "", file) ), "(seed=1)") )
}