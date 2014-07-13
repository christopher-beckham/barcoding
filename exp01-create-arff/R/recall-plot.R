library(RColorBrewer)

args = commandArgs(TRUE)

filename = args[1]
len = args[2]

if( len == "0") {
  len = "full"
}

df=read.csv(filename);

dfa = data.frame(class=factor(), recall=numeric(0))
levels(dfa$class) = levels(df$class)

for( i in 1:length(unique(df$class)) ) {
  dfa[i, ] = c( as.character( unique(df$class)[i] ),
              mean(df[ df$class == unique(df$class)[i], ]$recall) )
}

# ugly shit
idx = order(dfa$recall, decreasing=TRUE)
sorted = dfa[idx, ]
sorted$recall = as.numeric(sorted$recall)

# http://davetang.org/muse/2012/04/26/making-a-barplot-in-r/

# bottom left top right

png(filename=paste("graphs/",len,".png",sep=""))
par(mar=c(10,5,5,5))
barplot(sorted$recall, names.arg=sorted$class, col=brewer.pal(10, "Spectral"), las=2,
        main=paste("Mean recall for ",len," bp fragments",sep=""))
abline(a=0.5,b=0,lty=2, lwd=3)
dev.off()