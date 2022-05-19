The soft of this subject that needed.

**fastq-dum, bwa-mem2, gatk, samtools, bgzip, tabix.**

### 1. Before SNP calling, the sequencing adaptor and low quality reads must be reomved, the fq file must be clean reads, it can be done by fastq-dump or trimmomatic.
### 2. Build index of reference genome. Example:
```shell
samtools faidx ../genome/S_bicolor_v3_genomic.fna  ###The index of samtools 
bwa-mem2 index ../genome/S_bicolor_v3_genomic.fna   ###The index of bwa-mem2  
gatk CreateSequenceDictionary -R ../genome/S_bicolor_v3_genomic.fna \
-O ../genome/S_bicolor_v3_genomic.fna.dict ###It should be noted is that the prefix of .dict file need to be the same as fasta file and be in the same path, so that it can be found by GATK.
```

### 3. Get the gvcf run script, run the gatk_gvcf.pl, and it can generate a gatk_gvcf.sh file.
```shell
perl gatk_gvcf.pl
```

### 4. Run the comand in the gatk_gvcf.sh, and it will generate the gvcf file of each sample.
### 5. Combine the gvcf file of all samples to one file. It can generate the run file by the script of get_CombineGVCFs.pl, and then run CombineGVCFs.sh file, or run the following code.
```shell
gatk CombineGVCFs \
-R ../genome/S_bicolor_v3_genomic.fna \
--variant ../out/gatk/snp_caller/gvcf/Saccharum-T1.g.vcf  \
--variant ../out/gatk/snp_caller/gvcf/Saccharum-T2.g.vcf  \
--variant ../out/gatk/snp_caller/gvcf/Saccharum-T3.g.vcf  \
--variant ../out/gatk/snp_caller/gvcf/Saccharum-T4.g.vcf  \
--variant ../out/gatk/snp_caller/gvcf/Saccharum-T5.g.vcf  \
--variant ../out/gatk/snp_caller/gvcf/Saccharum-T6.g.vcf  \
--variant ../out/gatk/snp_caller/gvcf/Saccharum-T7.g.vcf  \
--variant ../out/gatk/snp_caller/gvcf/Saccharum-T8.g.vcf  \
--variant ../out/gatk/snp_caller/gvcf/Saccharum-T9.g.vcf  \
--variant ../out/gatk/snp_caller/gvcf/Saccharum-T10.g.vcf  \
…… …… ……
-O ../out/gatk/snp_caller/gvcf/Saccharum.g.vcf
```
### 6. Get the vcf file .
```shell
gatk GenotypeGVCFs \
 -R ../genome/S_bicolor_v3_genomic.fna \
 -V ../out/gatk/snp_caller/gvcf/Saccharum.g.vcf \
 -O ../out/gatk/snp_caller/Saccharum.vcf
```
### 7. Compressed vcf file and build index.
```shell
bgzip -f ../out/gatk/snp_caller/Saccharum.vcf
tabix -p vcf ../out/gatk/snp_caller/Saccharum.vcf.gz
```

### 8. Rename chromosome.
```shell
bcftools annotate --rename-chrs chr_name_change.txt ../out/gatk/snp_caller/Saccharum.vcf.gz |bgzip -c >../out/gatk/snp_caller/Saccharum_rename.vcf.gz ###chr_name_change.txt is a file that contain the chromosome name of old and new, one chromosome one line, split by "\t", example: NC_012870.2	1
tabix -p vcf ../out/gatk/snp_caller/Saccharum_rename.vcf.gz
```

### 9. Select the SNP and  restrict alleles to bi-allelic.
```shell
gatk SelectVariants --java-options -Xmx50g -V ../out/gatk/snp_caller/Saccharum_rename.vcf.gz \ 
--select-type-to-include SNP \
-L 1 -L 2 -L 3 -L 4 -L 5 -L 6 -L 7 -L 8 -L 9 -L 10 \
--restrict-alleles-to BIALLELIC
-O ../out/gatk/snp_caller/chr1-10.vcf.gz 
```