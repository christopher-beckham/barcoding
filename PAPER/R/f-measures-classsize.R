png(filename="f-measures-classsize.png", width=672, height=574, pointsize=14)

par(mfrow=c(2,3))

files = c("ibol.nb.s1", "ibol.rf.s1", "res50k.genus.nb.s1", "res50k.genus.rf.s1", "res50k.family.nb.s1", "res50k.family.rf.s1")
for(file in files) {
  df = read.csv(paste("f-measures/",file,".fmeasure",sep=""))
  plot(x=df$count, y=df$f_measure, pch=19, xlim=c(0,400),
       xlab="Class", ylab=paste("F-measure ( median = ", median(df$f_measure), ")"),
       main=paste(gsub("res50k", "nucleotide", gsub(".s1", "", file) ), "(seed=1)") )
}

dev.off()


#############

#for(file in files) {
#  df = read.csv(paste("f-measures/",file,".fmeasure",sep=""))
#  print(paste(file, median(df$f_measure)))
#}