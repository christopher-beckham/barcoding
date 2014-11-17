#library(foreign)

# 650 x 540

filenames = c("../output/ibol.species.s1.big.456.dist",
              "../output/res50k.family.s1.big.456.dist",
              "../output/res50k.genus.s1.big.456.dist")

names = c("iBOL Species", "Nucleotide Family", "Nucleotide Genus")

#png(filename="figure-classdist.png", width=672, height=574, pointsize=16)
pdf(file="figure-classdist.pdf")

par(mfrow=c(2,2))

for( i in 1:3 ) {
  df = read.csv(filenames[i], header=TRUE)
  plot(table(df$class), xaxt="n", ylab="Frequency", xlab="Class", main=paste("Class distribution", names[i]))
}

dev.off()

# --------------