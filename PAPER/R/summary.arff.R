library(foreign)

summary.arff = function(df, name) {
  return( c(name, length(unique(df$class)), nrow(df), ncol(df)) )
}

tb = data.frame(name=character(), classes=character(), instances=character(),
                features=character(), stringsAsFactors=FALSE)
tb[1,] = c(NA,NA,NA,NA)

for(i in 1:5) {
  df = read.arff(paste("../output/ibol.s",i,".arff",sep=""))
  tb = rbind( tb, summary.arff(df, paste("ibol",i)) )
}

for(i in 1:5) {
  df = read.arff(paste("../output/res50k.family.s",i,".arff",sep=""))
  tb = rbind( tb, summary.arff(df, paste("res50k.family",i)) )
}

for(i in 1:5) {
  df = read.arff(paste("../output/res50k.genus.s",i,".arff",sep=""))
  tb = rbind( tb, summary.arff(df, paste("res50k.genus",i)) )
}