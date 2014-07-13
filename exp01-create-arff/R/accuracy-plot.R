library(RColorBrewer)

args = commandArgs(TRUE)

filename = args[1]
len = args[2]

if( len == "0") {
  len = "full"
}

df=read.csv("G:/barcoding/output/accuracy.txt");

dfa = data.frame(len=integer(0), accuracy=numeric(0))
levels(dfa$class) = levels(df$class)

for( i in 1:length(unique(df$len)) ) {
  dfa[i, ] = c( as.character( unique(df$len)[i] ),
              mean(df[ df$len == unique(df$len)[i], ]$accuracy) )
}
