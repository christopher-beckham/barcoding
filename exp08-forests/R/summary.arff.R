library(foreign)

summary.arff = function(df, name) {
  print(paste("Summary for data frame:", name))
  print(paste("Number of unique classes:", length(unique(df$class))))
  print(paste("Number of instances:", nrow(df)))
  print(paste("Number of features:", ncol(df)))
}

df = read.arff("../output/ibol.s1.arff")
summary.arff(df, "ibol")

df = read.arff("../output/res50k.family.s1.arff")
summary.arff(df, "res50k.family")

df = read.arff("../output/res50k.genus.s1.arff")
summary.arff(df, "res50k.genus")