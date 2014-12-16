#library(foreign)

# 650 x 540

filenames = c("R/family-dist.csv",
              "R/genus-dist.csv",
              "R/species-dist.csv")

names = c("iBOL Species", "Nucleotide Family", "Nucleotide Genus")

#png(filename="figure-classdist.png", width=672, height=574, pointsize=16)
pdf(file="R/figure-classdist.pdf")

par(mfrow=c(2,2))

for( i in 1:3 ) {
  df = read.csv(filenames[i], header=TRUE)
  plot(table(df$class), xaxt="n", ylab="Frequency", xlab="Class", main=paste("Class distribution", names[i]))
}

dev.off()

# --------------