#!/usr/bin/perl
use warnings;
use strict;

my @samples=();
for(my $i=1;$i<=40;$i++){
		my $s = "Saccharum-T".$i;
		push(@samples, $s);
}

my $ref_fa = ".../genome/S_bicolor_v3_genomic.fna";

open(OUT, ">./CombineGVCFs.sh");
print OUT "gatk CombineGVCFs \\\n";
print OUT "-R $ref_fa \\\n";

foreach my $sample(@samples){
	my $gvcf = "../out/gatk/snp_caller/gvcf/".$sample.".g.vcf";
	print OUT "--variant $gvcf \\\n";
}
my $conbine_gvcf = "../out/gatk/snp_caller/gvcf/Saccharum.g.vcf";
print OUT "-O $conbine_gvcf \n";
