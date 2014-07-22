library(RColorBrewer)

args = commandArgs(TRUE)

filename = args[1]
len = args[2]

if( len == "0") {
  len = "full"
}

df=read.csv("G:/barcoding/output/class-dist.csv");

dfa = data.frame(len=integer(0), accuracy=numeric(0))
levels(dfa$class) = levels(df$class)

for( i in 1:length(unique(df$len)) ) {
  dfa[i, ] = c( as.character( unique(df$len)[i] ),
              mean(df[ df$len == unique(df$len)[i], ]$accuracy) )
}

png(filename=paste("graphs/class-dist.png",sep=""))
par(mar=c(10,5,5,5))
barplot(df$count,names.arg=df$class, col=brewer.pal(10, "Spectral"), las=2, main="Class distribution")
dev.off()