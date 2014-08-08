# requires caret package!
library(caret)

df = read.csv("../output/res50k.csv", na.strings="?")

# remove any attributes that are all zeroes (for speedup)
#for( i in 1:num.features ) {
#  if ( all.equal(0, sum(df[,i])) == TRUE ) {
#    df[,i] = NULL
#  }
#}
num.features = ncol(df)-1

num.folds = 10
folds = createFolds(df$class, k=num.folds-1)

train = {}
test = {}
test.idx = 1
for (i in 1:length(folds)) {
  if( i == test.idx ) {
    test = folds[[test.idx]]
  } else {
    train = c(train, folds[[i]])
  }
}

train = df[train,][1:1000,]
test = df[test,][1:1000,]

train.classes = unique(train$class)
# copy length(train.classes) of train into a new dataframe called train.means
train.means = train[1:length(train.classes),]
rownames(train.means) = NULL

# --------------------------

for( i in 1:length(train.classes) ) {
  print(i)
  # get me all instances in the training set with class == train.classes[i],
  instances = train[train$class == train.classes[i],]
  # then take the column means and put this in train.means                 
  colmeans = colMeans( instances[1:(ncol(train)-1)] )
  train.means[i, 1:(ncol(train)-1) ] = colmeans
  train.means[i,]$class = train.classes[i]
}

# predict
test.instance = test[1,]

train.mean.min = 100000
train.mean.min.idx = 0
# for each instance in train.means
for (c in 1:nrow(train.means)) {
  print(c)
  mse = sum((train.means[c,1:num.features] - test.instance[1,1:num.features])^2)
  if( mse < train.mean.min ) {
    train.mean.min = mse
    train.mean.min.idx = c
  }
}
