#png(filename="f-measures-classsize.png", width=672, height=574, pointsize=16)
pdf(file="f-measure/f-measures-histogram.pdf")

par(mfrow=c(2,3))

files = c("ibol.species.seq450.k14",
          "ibol.species.seq600.k15",
          "res50k.genus.seq450.k15",
          "res50k.genus.seq600.k15",
          "res50k.family.seq450.k16", 
          "res50k.family.seq600.k15")

names = c("ibol.species.seq450.k14",
          "ibol.species.seq600.k15",
          "ncbi.genus.seq450.k15",
          "ncbi.genus.seq600.k15",
          "ncbi.family.seq450.k16", 
          "ncbi.family.seq600.k15")

for(i in 1:length(files)) {
  df = read.csv(paste("f-measure/",files[i],".arff.result.fmeasure",sep=""))
  #hist(df$f_measure[1:nrow(df)-1],breaks=20,main=names[i],xlab="F-Measure")
  boxplot(df$f_measure[1:nrow(df)-1], main=names[i], col="grey", ylab="F-Measure")
  #abline(v=0.5, lty="dashed")
  print(length(which(df$f_measure < 0.5)) / (nrow(df)-1))
}

dev.off()