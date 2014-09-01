library(foreign)

df = read.arff("../output/ibol.s1.arff")

# --------------

par(mfrow=c(3,3))

# plot class histogram

plot(table(df$class), xaxt="n", ylab="Frequency", xlab="Class", main="Class distribution of iBOL set")

# various histograms

set.seed(12)

cols = round( runif(8, min=1, max=ncol(df)) )

for( i in cols ) {
  hist(df[,i], breaks=10, main=paste("Histogram of", colnames(df)[i], "( #", i, ")"), xlab=colnames(df)[i])
}