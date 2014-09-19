library(foreign)

# 650 x 540

filenames = c("../output/ibol.s1.arff",
              "../output/res50k.family.s1.arff",
              "../output/res50k.genus.s1.arff")

names = c("iBOL (species)", "Nucleotide (family)", "Nucleotide (genus)")

png(filename="figure-classdist.png", width=650, height=540)

par(mfrow=c(2,2))

for( i in 1:3 ) {
  df = read.arff(filenames[i])
  plot(table(df$class), xaxt="n", ylab="Frequency", xlab="Class", main=paste("Class distribution", names[i]))
}

dev.off()

# --------------