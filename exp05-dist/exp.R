df = read.csv("../output/res50k.csv")

# requires caret package!
library(caret)

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

train = df[train,][1:200,]
test = df[test,][1:200,]

train.means = train[0,]
rownames(train.means) = NULL

# --------------------------
# train.means[1,] = c( colMeans( train[train$class == "Xestia",][1:3918] ), "Xestia" )

train.classes = unique(train$class)
for( i in 1:length(train.classes) ) {
  # get me all instances in the training set with class == train.classes[i],
  instances = train[train$class == train.classes[i],]
  # then take the column means and put this in train.means                 
  colmeans = colMeans( instances[1:ncol(train)-1] )
  train.means[i, ] = c(colmeans, as.character(train.classes[i]))
}