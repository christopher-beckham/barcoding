library(foreign)

df = read.arff("../output/ibol.s1.arff")

png(filename="figure-featuredist.png", width=672, height=574)

par(mfrow=c(3,3))

# various histograms
set.seed(12)
cols = round( runif(9, min=1, max=ncol(df)) )
for( i in cols ) {
  hist(df[,i], breaks=10, main=paste("Histogram of", colnames(df)[i], "( #", i, ")"), xlab=colnames(df)[i])
}

dev.off()