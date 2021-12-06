rm(list=ls())
setwd("D:\\workstation\\R\\SNP\\PCA")

####eigenvec########
pca_vec <- read.table("chr1-10_filtered3.vec", sep = "\t", header = F)
pca_vec <- pca_vec[,1:5]
colnames(pca_vec) <- c("group", "id", "PC1", "PC2", "PC3")
pca_vec <- pca_vec[order(pca_vec$group),]
####eigenval######
pca_val <- read.table("pca.val",  header = F)
pca_val <- pca_val$V1
pca_per_x <- paste("PC1(", round(100*pca_val[1]/sum(pca_val),2), "%)", sep = "")
pca_per_y <- paste("PC2(", round(100*pca_val[2]/sum(pca_val),2), "%)", sep = "")
pca_per_z <- paste("PC3(", round(100*pca_val[3]/sum(pca_val),2), "%)", sep = "")
######################################3d PCA #####################
library(scatterplot3d)
mypal <-rainbow(length(unique(pca_vec$group)))

i = 1
color_list <- c()
pch_list <- c()
for (cluster in unique(pca_vec$group)){
  color_list <- c(color_list, rep(mypal[i], length(which(pca_vec$group == cluster))))
  pch_list <- c(pch_list, rep(i, length(which(pca_vec$group == cluster))))
  i = i + 1
}

#pdf("pca3d.pdf")
png("PCA3d.png", width = 800*3, height = 800*3, res=100*3)
s3d <- scatterplot3d(pca_vec[,3:5], col.axis="black", col.grid="grey",  angle=40, scale.y=0.8,  lwd=3,
              xlab=pca_per_x, ylab=pca_per_y, zlab=pca_per_z,color = color_list, cex.symbols = 2, pch = pch_list)

legend("topleft", pch = c(1,2,3,4), col = unique(color_list), bty='n',legend = unique(pca_vec$group), cex = 1)
dev.off()

####################################2d PCA ####################
library(ggplot2)

#pdf("pca2d.pdf")
png("PCA2d.png", width = 867*3, height = 558*3, res=100*3)
ggplot(pca_vec,aes(x=PC1,y=PC2,color=group,shape = group)) + geom_point() + 
  stat_ellipse(level = 0.95, show.legend = F) +
  xlab(pca_per_x) + ylab(pca_per_y) +  
  theme_bw()
dev.off()

