rm(list=ls())
setwd("D:\\workstation\\R\\SNP\\admixture")

library(ggplot2)
library(cowplot)
library(stringr)
library(reshape2)


####cluster#######
df_order <- read.table("admixture/chr1-10_filtered3.4.Q", header = F, sep = " ")
out.dist=dist(df_order, method="euclidean")
out.hclust=hclust(out.dist,method="ward.D")
order_s <- out.hclust$order

df_sample <- read.table("admixture/chr1-10_filtered3.nosex", header = F, sep = "\t")
df_sample <- str_replace(df_sample[,1], "S.officinarum_", "")
df_sample <- str_replace(df_sample, " ", "")
df_sample <- df_sample[order_s]

col_panel <- rainbow(4)
#########i=4
i <- 4
file <- paste("admixture/chr1-10_filtered3.",i, ".Q", sep = "")
df <- read.table(file, header = F, sep = " ")
df <- df[order_s,]

df_new <- transform.data.frame(samples=df_sample, df) 

aql <- melt(df_new, id.vars = "samples")
aql$samples <- factor(x=aql$samples, levels = df_sample)
y_lab <- paste("K=", i, sep = "")
  
p4 <- ggplot(aql) + geom_bar(aes(x=samples, weight=value, fill=variable), position = "stack", width = 1) +
  scale_x_discrete(expand = c(0,0)) + scale_y_discrete(expand = c(0,0)) + 
  scale_fill_manual(values = col_panel[1:4]) +
  theme(legend.position = "none",
        panel.background = element_rect(fill="white"),
        axis.text.x = element_text(angle = 90, size = 10),
        axis.title.x = element_blank(),
        axis.ticks = element_blank(), axis.title.y = element_text(size = 13),
        panel.grid = element_blank()) + ylab(y_lab)
################i=3
i <- 3
file <- paste("admixture/chr1-10_filtered3.",i, ".Q", sep = "")
df <- read.table(file, header = F, sep = " ")
df <- df[order_s,]

df_new <- transform.data.frame(samples=df_sample, df) 

aql <- melt(df_new, id.vars = "samples")
aql$samples <- factor(x=aql$samples, levels = df_sample)
y_lab <- paste("K=", i, sep = "")

p3 <- ggplot(aql) + geom_bar(aes(x=samples, weight=value, fill=variable), position = "stack", width = 1) +
  scale_x_discrete(expand = c(0,0)) + scale_y_discrete(expand = c(0,0)) + 
  scale_fill_manual(values = c(col_panel[1],col_panel[3],col_panel[4])) +
  theme(legend.position = "none",
        panel.background = element_rect(fill="white"),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks = element_blank(), axis.title.y = element_text(size = 13),
        panel.grid = element_blank()) + ylab(y_lab)

################i=2
i <- 2
file <- paste("admixture/chr1-10_filtered3.",i, ".Q", sep = "")
df <- read.table(file, header = F, sep = " ")
df <- df[order_s,]

df_new <- transform.data.frame(samples=df_sample, df) 

aql <- melt(df_new, id.vars = "samples")
aql$samples <- factor(x=aql$samples, levels = df_sample)
y_lab <- paste("K=", i, sep = "")

p2 <- ggplot(aql) + geom_bar(aes(x=samples, weight=value, fill=variable), position = "stack", width = 1) +
  scale_x_discrete(expand = c(0,0)) + scale_y_discrete(expand = c(0,0)) + 
  scale_fill_manual(values = c(col_panel[4],col_panel[3])) +
  theme(legend.position = "none",
        panel.background = element_rect(fill="white"),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks = element_blank(), axis.title.y = element_text(size = 13),
        panel.grid = element_blank()) + ylab(y_lab)

####CV errors###
cv <- read.table("CV_error.txt", header = F)
colnames(cv) <- c("error")

p1 <- ggplot(NULL) + 
  geom_line(aes(x=seq(1,nrow(cv)), y=cv$error), stat = "identity") + 
  geom_point(aes(x=seq(1,nrow(cv)), y=cv$error), stat = "identity", size = 3) +
  theme_bw() + ylab("CV error") + 
  scale_x_continuous(breaks = seq(1,10,1)) +
  scale_y_continuous(breaks = seq(0.2,1,0.2)) +
  theme(panel.background = element_blank(),panel.grid = element_blank(),
        axis.title.x = element_blank(), axis.text = element_text(size = 12),
        axis.title.y = element_text(size = 13))


p_admixture <- plot_grid(p2,p3,p4, ncol = 1)

pdf("admixture/Fig/admixture4.pdf", width = 8.5, height = 1.25)
print(p4)
dev.off()

pdf("admixture/Fig/admixture3.pdf", width = 8.5, height = 1)
print(p3)
dev.off()

pdf("admixture/Fig/admixture2.pdf", width = 8.5, height = 1)
print(p2)
dev.off()

pdf("admixture/Fig/admixture1.pdf", width = 8.5, height = 1.5)
print(p1)
dev.off()


#########################Old############################
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

df_sample <- read.table("admixture/chr1-10_filtered3.nosex", header = F, sep = "\t")
df_sample <- str_replace(df_sample[,1], "S.officinarum_", "")
df_sample <- str_replace(df_sample, " ", "")
df_sample <- df_sample[order_s]

png("admixture_chr1-10_filtered3.png", width = 6000, height = 2200, res=300)
par(mfrow = c(3, 1), mai = c(0.3, 0.7, 0.1, 0), cex.axis = 1.5, cex.lab = 1.5, font=2)

for(i in c(4,3,2)){
  file <- paste("chr1-10_filtered3.",i, ".Q", sep = "")
  df <- read.table(file, header = F, sep = " ")

  df_new <- transform.data.frame(samples=df_sample, df) 
  df_new <- df[order_s,]
  aql <- melt(df_new, id.vars = "samples")
  aql$samples <- factor(x=aql$samples, levels = df_sample)
  y_lab <- paste("K=", i, sep = "")

  if(i == 2){
    barplot(t(as.matrix(aql)),col= rainbow(i),xlab="", ylab=y_lab, axes = T,  axisnames = T, border = NA, space = 0)
  }else{
    barplot(t(as.matrix(aql)),col= rainbow(i),xlab="", ylab=y_lab, axes = T,  axisnames = F, border = NA, space = 0)
  }
}  

dev.off()

#########################################################
