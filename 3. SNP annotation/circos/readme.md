### 1. Create "karyotype.sorghum.txt" file.
```shell
cd ../out/circos
perl create_karyotype.pl GCF_000003195.3_Sorghum_bicolor_NCBIv3_genomic.fna
```

### 2. Prepare file for the R script named get_density_file.R
  ##### Convert the gtf format to genepred format.
   ```shell
perl get_gpd_file.pl GCF_000003195.3_Sorghum_bicolor_NCBIv3_genomic.gtf   ###This script will creat a file named "gene.gpd" in data dir.
   ```

  #### Get the snp_POS.tb file 
  ```shell
  grep -v "^#" ../chr1-10_filtered3_vcf.vcf |cut -f 1,2 |less -S >data/snp_POS.tb
  ```

### 3. Run the get_density_file.R script get the gene and SNP density file.
### 4. Run circos.
Prepare the configure file in con folder, that contain ideogram.conf, ideogram.label.conf, ideogram.position.conf, r0r1.conf, ticks.conf, circos.conf.

```shell
/usr/bin/perl ~/soft/circos-0.69-9/bin/circos -conf conf/circos.conf
```
