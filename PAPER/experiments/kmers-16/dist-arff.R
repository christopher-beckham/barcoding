library(foreign)

df = read.arff("output/res50k.family.seq600.k16.arff")

#par(mfrow=c(3,4))
#for( idx in sample(1:ncol(df), 12, replace=FALSE) ) {
#  print(idx)
#  hist(df[,idx], main=colnames(df)[idx], breaks=20)
#}

# figure out indices
x = 1
y = 1
ll = list()
last_len = 1
for( i in 1:(length(colnames(df))-1) ) {
  if( nchar(gsub("_f","",colnames(df)[i])) > last_len ) {
    y = i-1
    ll = c(ll, list(c(x,y)))
    x = i
    last_len = last_len + 1
  }
}
y = ncol(df)-1
ll = c(ll, list(c(x,y)))

pdf(file="results/dist-arff.pdf", width=8, height=8)

set.seed(1)
par(mfrow=c(4,3))
for(i in 1:length(ll)) {
  nums = sample( ll[[i]][1]:ll[[i]][2], 2, replace=FALSE)
  for(j in 1:length(nums)) {
    hist(df[,nums[j]], main=gsub("_f","",colnames(df)[nums[j]]), breaks=20)
  }
}

dev.off()