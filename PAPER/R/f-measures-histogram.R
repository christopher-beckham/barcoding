#png(filename="f-measures-classsize.png", width=672, height=574, pointsize=16)
pdf(file="f-measures-histogram.pdf")

par(mfrow=c(2,3))

files = c("ibol.nb.s1", "ibol.rf.s1", "res50k.genus.nb.s1", "res50k.genus.rf.s1", "res50k.family.nb.s1", "res50k.family.rf.s1")
titles = c("iBOL Species NB", "iBOL Species RF", "Nucleotide Genus NB", "Nucleotide Genus RF",
           "Nucleotide Family NB", "Nucleotide Family RF")

for(i in 1:length(files)) {
  df = read.csv(paste("f-measures/",files[i],".fmeasure",sep=""))
  hist(df$f_measure[1:nrow(df)-1],breaks=20,main=titles[i],xlab="F-Measure")
  abline(v=0.5, lty="dashed")
  print(length(which(df$f_measure < 0.5)) / (nrow(df)-1))
}

dev.off()


#############

#for(file in files) {
#  df = read.csv(paste("f-measures/",file,".fmeasure",sep=""))
#  print(paste(file, median(df$f_measure)))
#}