## 1. Phylogenetic analysis
### (1) Fetch SNP sequence
```
cd population/phylogeny
python phylogeny/vcf2phylip.py i ../../chr1-10_filtered3_vcf.vcf --output-prefix filtered_snp -p -f -n -m8 
cat filtered_snp.min8.fasta |perl -ne "s/\*/-/g;s/S.officinarum_//;print;" >filtered_snp.min8.fa` ###Relace "*" to "-", and remove the sample name's prefix "S.officinarum_".
```
### (2) Phylogenetic analysis using MEGA.
```
The Step and parameter.
DATA-->Open a file-->Analyze-->Nucleotide Sequences-->No    ###open the filtered_snp.min8.fa file.
PHYLOGENY-->Construct/Neighbor-Joining Tree-->Yes
Test of Phylogeny : Bootstrap method
No. of Bootstrap replications : 1000
Model/Method : Maximum Composite Likelihood
Substitutions to Include : d: Transitions + Transversions
Rates among Sites : Uniform Rates
Pattern among Lineages : Same
Gaps : Partial deletion
Site coverage Cutoff (%) : 95
Save the tree and name as filtered_snp.min8.nwk
```
### (3) Draw phylogenetic tree using iTOL.
`Input the nwk tree into iTOL, generate the tree annotation file "colors_tol.txt" and "tol_color_strip.txt", dragging these files to phylogenetic tree in iTOL, and save the image.`
## 2. PCA analysis
###(1) Change the file format.
```
cd population/PAC
plink --bfile ../../chr1-10_filtered3 --recode --out chr1-10_filtered3
```
###(2) Create a population.txt file, the first column is the sample name, the second column is the group name.
`perl generate_par.pl`  ###This script will creat the smartpca.par, and the files that smartpca need.
###(3) PCA analysis using smartpca.
```
smartpca -p smartpca.par >pca.log ###PCA analysis
smartpca.perl -i pca.ped -a pca.pedsnp -b pca.pedind -o myfile.PCA -p myfile.plot -e myfile.evel -l myfile.log ###Also can run this command, if not generate smartpca.par file.
cat pca.vec|perl -ne 's/\s+$//;s/^\s+//;s/\s+/\t/g;s/:/\t/;print $_."\n";' >chr1-10_filtered3.vec ###Remove blank of each line in pca.vec file.
```
###(4) Draw a 2d or 3d PCA plot using the Rscript named pca.R. 
## 3. Population of genetic structure analysis.
`cd population/admixture`
### （1）Population structure analysis by admixture.
```
for i in {1..10}; do admixture --cv ../../chr1-10_filtered3.bed $i |tee log${i}.out; done
grep -h CV log*.out|perl -ne "s/CV.*:\s+//;print;" >CV_error.txt
```

