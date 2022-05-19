### 1. Download SnpEff software.
```shell
wget https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip 
unzip snpEff_latest_core.zip
```

### 2. Prepare the reference genome and annotation file.
```shell
cd $snpeffDir  ###Entry the file of snpEff install.
mkdir data  ### create a dir named data in the snpEff file.
mkdir data/S_bicolor  ### create a dir named S_bicolor in data file.
perl chr_rename.pl -i GCF_000003195.3_Sorghum_bicolor_NCBIv3_genomic.gtf \
-o ~/soft/snpEff/data/S_bicolor/genes.gtf 
perl chr_rename.pl -i GCF_000003195.3_Sorghum_bicolor_NCBIv3_genomic.fna \
-o ~/soft/snpEff/data/S_bicolor/sequences.fa
```

### 3. Build the database.
```shell
echo "S_bicolor.genome : Sorghum_bicolor" >>snpEff.config
java -jar snpEff.jar build -c snpEff.config -gtf22 -v S_bicolor
```

### 4. run snpEff
```shell
mkdir ../out/snpeff
java -jar ~/soft/snpEff/snpEff.jar eff S_bicolor ../out/filter/chr1-10_filtered3_vcf >../out/snpeff/chr1-10.snpeff.vcf & 
```
