df = read.csv("results/freq-vs-binary-R.csv")

pdf(file="results/graph.pdf", width=8, height=8)
par(mfrow=c(3,4))
for( i in seq(1, nrow(df), 6) ) {
  subset = df[ i:(i+6-1), ]
  # points
  title = gsub("output/", "", as.character(subset$dataset[1]))
  title = gsub("res50k", "ncbi", title)
  plot(x=1:6, y=subset$nb, xlab="k", ylab="Accuracy (%)", ylim=c(0,100),
       pch=19, col="blue", cex=0.5, main=title)
  points(x=1:6, y=subset$rf, pch=19, col="red", cex=0.5)
  points(x=1:6, y=subset$nb_binary, pch=19, col="orange", cex=0.5)
  points(x=1:6, y=subset$rf_binary, pch=19, col="green", cex=0.5)
  # lines
  lines(x=1:6, y=subset$nb, pch=19, col="blue")
  lines(x=1:6, y=subset$rf, pch=19, col="red")
  lines(x=1:6, y=subset$nb_binary, pch=19, col="orange")
  lines(x=1:6, y=subset$rf_binary, pch=19, col="green")
  # legend
  legend('bottomright', legend=c("NB","RF","NB (b)","RF (b)"),
         fill=c("blue","red","orange","green"), cex=0.6)
}
dev.off()