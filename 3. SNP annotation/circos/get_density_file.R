rm(list=ls())
setwd("./") ##Change the file to work file which contain the gene.gpd and snp_POS.tb file

genes_glyph <- read.table("data/gene.gpd", sep = "\t", header = F)
colnames(genes_glyph)=c("acc", "chr", "start", "end")

###Select and the genes on chromosome, and change the chromosome name.
chr_row <- grep("NC_01287", genes_glyph$chr)
genes_glyph <- genes_glyph[chr_row, ]
genes_glyph$chr <- as.numeric(gsub("NC_01287(\\d+)\\.2", "\\1", genes_glyph$chr)) + 1

karyotype <- read.table("karyotype.sorghum.txt", sep = "\t", header = F)
chr_size <- data.frame(chr=karyotype[,3], size=karyotype[,6])

gene_density_500k <- data.frame(chr=c(), start=c(), end=c(), value=c())
for(i in seq(1:10)){
  #####get each of chrosome subset#################
  
  sub_genes_glyph <- subset(genes_glyph, chr==i)
  #####get the site of the gene centre###################
  centre_site <- round((sub_genes_glyph$start + sub_genes_glyph$end)/2)
  start = 0
  end = 499999
  #####count the gene number of in 500000bp region.
  while(end < subset(chr_size, chr==paste0("sb",i))$size){
    gene_num <- length(subset(centre_site, centre_site<end & centre_site>start))
    chr_gene_density <- data.frame(chr=paste0("sb",i), start =start, end=end, value=gene_num)
    gene_density_500k <- rbind(gene_density_500k, chr_gene_density)
    start = end + 1
    end = end + 500000
  }
}

options(scipen=200)

#max(gene_density_500k$value)
gene_density_500k_log2 <- gene_density_500k
gene_density_500k_log2$value <- round(log((gene_density_500k_log2$value + 1), 2), 3)
write.table(gene_density_500k, "data/gene_density_500k.txt", sep = "\t", quote = FALSE, col.names = F, row.names = F) 
write.table(gene_density_500k_log2, "data/gene_density_500k_log2.txt", sep = "\t", quote = FALSE, col.names = F, row.names = F) 
################SNP density##################
snp_POS <- read.table("data/snp_POS.tb", sep = "\t", header = F)
colnames(snp_POS)=c("CHROM", "POS")

snp_density_500k <- data.frame(chr=c(), start=c(), end=c(), value=c())
for(i in seq(1:10)){
  #####get each of chrosome subset#################
  chr_snp <- subset(snp_POS, CHROM==i)
  #####get the site of the gene centre###################
  start = 0
  end = 499999
  while(end <= subset(chr_size, chr==paste0("sb",i))$size){
    snp_num <- length(subset(chr_snp, POS<=end & POS>=start)$POS)
    chr_snp_density <- data.frame(chr=paste0("sb",i), start =start, end=end, value=snp_num)
    snp_density_500k <- rbind(snp_density_500k, chr_snp_density)
    start = end + 1
    end = end + 500000
  }
}

snp_density_500k_log2 <- snp_density_500k
snp_density_500k_log2$value <- round(log((snp_density_500k_log2$value + 1), 2),3)
write.table(snp_density_500k, "data/snp_density_500k.txt", sep = "\t", quote = FALSE, col.names = F, row.names = F) 
write.table(snp_density_500k_log2, "data/snp_density_500k_log2.txt", sep = "\t", quote = FALSE, col.names = F, row.names = F) 

