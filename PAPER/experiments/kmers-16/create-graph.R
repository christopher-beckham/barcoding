df = read.csv("results/feb5-result-csv-cleaned.csv")

pdf(file="results/feb5-graph.pdf", width=8, height=8)

par(mfrow=c(3,4))
for( i in seq(1, nrow(df), 6) ) {
  subset = df[ i:(i+6-1), ]
  # points
  title = gsub("output/", "", as.character(subset$dataset[1]))
  title = gsub("res50k", "ncbi", title)
  plot(x=1:6, y=subset$nb, xlab="k", ylab="Accuracy (%)", ylim=c(0,100),
       pch=19, col="blue", cex=0.5, main=title)
  points(x=1:6, y=subset$rf, pch=19, col="red", cex=0.5)
  # lines
  lines(x=1:6, y=subset$nb, pch=19, col="blue")
  lines(x=1:6, y=subset$rf, pch=19, col="red")
  # legend
  legend('bottomright', legend=c("NB","RF"),
         fill=c("blue","red"), cex=0.6)
}

dev.off()