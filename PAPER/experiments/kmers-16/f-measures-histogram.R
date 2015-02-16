#png(filename="f-measures-classsize.png", width=672, height=574, pointsize=16)
pdf(file="f-measure/f-measures-histogram.pdf", width=8, height=8)

par(mfrow=c(3,4))

files = list.files(path="f-measure/", pattern="*.result$")

for(i in 1:length(files)) {
  df = read.csv(paste("f-measure/",files[i],".fmeasure",sep=""))
  df = df[ -which (df$class == "WEIGHTED F-MEASURE" ), ]
  #hist(df$f_measure[1:nrow(df)-1],breaks=20,main=names[i],xlab="F-Measure")
  ttl = gsub(".result", "", files[i])
  ttl = gsub("res50k", "ncbi", ttl)
  ttl = gsub(".rf$", "\n(RF)", ttl)
  ttl = gsub(".nb$", "\n(NB)", ttl)
  boxplot(df$f_measure[1:nrow(df)-1], main=ttl, col="grey", ylab="F-Measure")
  #abline(v=0.5, lty="dashed")
  print(length(which(df$f_measure > 0.5)) / (nrow(df)))
  legend('bottomright', paste(round(length(which(df$f_measure > 0.5)) / (nrow(df)), 2)), bty="n")
}

dev.off()