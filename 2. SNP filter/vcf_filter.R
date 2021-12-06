#!/usr/bin/env Rscript
## Display the distribution of quality in SNPs.
## Writed by Xiao-wen Hu(xiaowenhu2018@163.com), 2020.9.23.

rm(list = ls())
setwd("D:/workstation/R/SNP/filter")

vcf_data = read.table("r20_quality_value.tb", header = T)

######DP#############
DP <- vcf_data$DP
DP <- DP[!is.na(DP)]
#nrow(vcf_data[which(vcf_data$DP<2),])/nrow(vcf_data)

######QD#############
QD <- vcf_data$QD
QD <- QD[!is.na(QD)]
#nrow(vcf_data[which(vcf_data$QD<2),])/nrow(vcf_data)

######FS#############
FS <- vcf_data$FS
FS <- FS[!is.na(FS)]

#nrow(vcf_data[which(vcf_data$FS>30),])/nrow(vcf_data)

######SOR#############
SOR <- vcf_data$SOR
SOR <- SOR[!is.na(SOR)]

#nrow(vcf_data[which(vcf_data$SOR>5),])/nrow(vcf_data)

######MQ#############
MQ <- vcf_data$MQ
MQ <- MQ[!is.na(MQ)]

#nrow(vcf_data[which(vcf_data$MQ<40),])/nrow(vcf_data)
######MQRankSum#####
MQRankSum <- vcf_data$MQRankSum
MQRankSum <- MQRankSum[!is.na(MQRankSum)]

#######ReadPosRankSum#######
ReadPosRankSum <- vcf_data$ReadPosRankSum
ReadPosRankSum <- ReadPosRankSum[!is.na(ReadPosRankSum)]
#####################################################
library(cowplot) ##if not have cowplot package, should install first.
p1 <- ggplot(NULL, aes(x=DP)) + geom_line(stat="density") + scale_x_continuous(limits = c(0, 1000)) + theme_cowplot()
p2 <- ggplot(NULL, aes(x=QD)) + geom_line(stat="density") + theme_cowplot()
p3 <- ggplot(NULL, aes(x=FS)) + geom_line(stat="density")  + scale_x_continuous(limits = c(0, 11)) + theme_cowplot()
p4 <- ggplot(NULL, aes(x=SOR)) + geom_line(stat="density")  + scale_x_continuous(limits = c(0, 15)) + theme_cowplot()
p5 <- ggplot(NULL, aes(x=MQ)) + geom_line(stat="density") + theme_cowplot()
p6 <- ggplot(NULL, aes(x=MQRankSum)) + geom_line(stat="density")  + scale_x_continuous(limits = c(-5, 5)) + theme_cowplot()
p7 <- ggplot(NULL, aes(x=ReadPosRankSum)) + geom_line(stat="density")  + scale_x_continuous(limits = c(-5, 5)) + theme_cowplot()

plot2by2 <- plot_grid(p1, p2, p3, p4, p5, p6, p7,
                      labels=c("A", "B", "C", "D", "E", "F", "G"), ncol = 2)
save_plot("plot2by2.png", plot2by2,
          ncol = 2, # we're saving a grid plot of 2 columns
          nrow = 3, # and 3 rows
          # each individual subplot should have an aspect ratio of 1.3
          base_aspect_ratio = 1.3
)
