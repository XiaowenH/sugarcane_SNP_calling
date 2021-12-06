rm(list=ls())
setwd("D:\\workstation\\R\\SNP\\admixture")
####CV errors###
cv <- read.table("CV_error.txt", header = F)
png("CV_error.png", width = 6000, height = 2000, res=300)
plot(1:10,cv$V1,typ="b", pch=20,  ylab = "CV error", xlab = "", cex.axis = 1.5, cex.lab = 1.5, cex=3)
dev.off()
####cluster#######
df_order <- read.table("chr1-10_filtered3.4.Q", header = F, sep = " ")
out.dist=dist(df_order, method="euclidean")
out.hclust=hclust(out.dist,method="ward.D")
order_s <- out.hclust$order

png("admixture_chr1-10_filtered3.png", width = 6000, height = 2200, res=300)
par(mfrow = c(3, 1), mai = c(0.3, 0.7, 0.1, 0), cex.axis = 1.5, cex.lab = 1.5, font=2)

for(i in c(4,3,2)){
  file <- paste("chr1-10_filtered3.",i, ".Q", sep = "")
  df <- read.table(file, header = F, sep = " ")

  df_new <- df[order_s,]
  rownames(df_new) <- paste(rep("K", nrow(df_new)), rownames(df_new), sep = "")
  yname <- paste("K =", i)
  if(i == 2){
    barplot(t(as.matrix(df_new)),col= rainbow(i),xlab="", ylab=yname, axes = T,  axisnames = T, border = NA, space = 0)
  }else{
    barplot(t(as.matrix(df_new)),col= rainbow(i),xlab="", ylab=yname, axes = T,  axisnames = F, border = NA, space = 0)
  }
}  

dev.off()

#########################################################
