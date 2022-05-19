### 1. Before this subject, the vcf file must be get in the previous step "SNP calling".
### 2. Select a fraction of variants(20%) at random from the snp.vcf file for quality analysis.
```shell
mkdir ../out/filter
gatk SelectVariants -V ../out/gatk/snp_caller/chr1-10.vcf.gz --select-random-fraction 0.2 -O ../out/filter/chr1-10_r20_snp.vcf.gz 
```
### 3. Extract fields from a VCF file to a tab-delimited table.
```shell
gatk VariantsToTable -V ../out/filter/chr1-10_r20_snp.vcf.gz \
-F CHROM -F POS \
-ASF DP -ASF QD  -ASF MQ  -ASF FS  -ASF SOR -ASF MQRankSum -ASF ReadPosRankSum  \
-O ../out/filter/quality_value.tb 
```
### 4. Do SNP quality analysis using vcf_filter.R script.
### 5. Filter variant calls based on INFO and/or FORMAT annotations (Hard filters a VCF).
```shell
gatk VariantFiltration \
    -V ../out/filter/chr1-10.vcf.gz \
    --filter-expression "DP < 2 || DP > 10000 || QD < 2.0 || MQ < 34.0 || FS > 10.0 || SOR > 5.0" \
	-cluster 3 -window 10
    --filter-name "Filter" \
    -O ../out/filter/chr1-10_filter1.vcf.gz
	
gatk SelectVariants -V ../out/filter/chr1-10_filter1.vcf.gz -O chr1../out/filter/chr1-10_filtered1.vcf.gz -select "FILTER == PASS"
rm ../out/filter/chr1-10_filter1.vcf.gz 
```
### 6. Filter according to allele and genotype.
```shell
vcftools --gzvcf  ../out/filter/chr1-10_filtered1.vcf.gz --plink --out ../out/filter/chr1-10_filtered1
plink --file ../out/filter/chr1-10_filtered1 --maf 0.05 --geno 0.1 --recode --out ../out/filter/chr1-10_filtered2
plink --file ../out/filter/chr1-10_filtered2 --indep-pairwise 300 1 0.4 --out ../out/filter/ld
plink --file ../out/filter/chr1-10_filtered2 --extract ld.prune.in --make-bed --out ../out/filter/chr1-10_filtered3   ###LD filter
plink --bfile ../out/filter/chr1-10_filtered3 --recode vcf-iid --out ../out/filter/chr1-10_filtered3_vcf     ###conver to vcf format
cd filter
vcftools --vcf ../chr1-10_filtered3_vcf.vcf --freq --out freq_summary.txt  ###Calculate allele frequency
```
