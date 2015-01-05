#library(foreign)

# 650 x 540

filenames = list.files(path="tally-classes", pattern="*.txt", full.names=T, recursive=FALSE)

pdf(file="tally-classes/figure-classdist.pdf")

par(mfrow=c(4,3))

for( i in 1:length(filenames) ) {
  df = read.csv(filenames[i], header=TRUE)
  title = gsub(".txt", "", filenames[i])
  title = gsub("tally-classes/", "", title)
  title = gsub("res50k", "ncbi", title)
  if( title == "ibol.species.seq600.k11.arff" ) {
    next
  }
  plot(table(df$class), xaxt="n", ylab="Frequency", xlab="Class", main=title )
}

dev.off()

# --------------