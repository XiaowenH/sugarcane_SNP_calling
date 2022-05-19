#!/usr/bin/perl

####################The script description##################
###Before run this script, samtools, bwa-mem2, gatk must be installed.


#************************************************************


use warnings;
use strict;


my @samples=();
for(my $i=1;$i<=40;$i++){
		my $s = "Saccharum-T".$i;
		push(@samples, $s);
}
		
my $ref_fa = "../genome/S_bicolor_v3_genomic.fna";
my $fastq_dir = "../samples";
my $cpu_use = 24;
my $outfile = "../out/gatk";

open(OUT, ">./gatk_gvcf.sh");

foreach my $s(@samples){
	my $s1 = $fastq_dir."/".$s."_good_1.fq.gz";
	my $s2 = $fastq_dir."/".$s."_good_2.fq.gz";
	
	my $mem_R = '@RG\tID:foo\tPL:illumina\tSM:S.officinarum_K'.$s;
		$mem_R = "'".$mem_R."'";
	
	my $out_bam_dir = $outfile."/bam";
	system("mkdir $out_bam_dir") unless(-e $out_bam_dir);
	my $out_bam = $out_bam_dir."/".$s.".bam";
	
	###mapping reads to reference genome
	system("bwa-mem2 mem -t $cpu_use -R $mem_R $ref_fa $s1 $s2 |samtools  view -\@ $cpu_use -Sb >$out_bam ");
	
	my $sorted_bam = $out_bam_dir."/".$s.".sorted.bam";
	system("samtools sort -\@ $cpu_use -O bam -o $sorted_bam $out_bam");
	system("rm $out_bam");

	my $snp_caller = $outfile."/snp_caller";
	system("mkdir $snp_caller") unless(-e $snp_caller);
	
	my $markdup_bam =  $snp_caller."/".$s.".sorted.markdup.bam";
	my $metrics = $snp_caller."/".$s.".sorted.markdup_metrics.txt";
	
	####marker the PCR repeat
	system("gatk --java-options '-Xmx50g' MarkDuplicates -I $sorted_bam -O $markdup_bam -M $metrics");
	system("rm $sorted_bam");
	
	######validate bam file
	my $validate = $snp_caller."/".$s.".validate";
	system("gatk --java-options '-Xmx50g' ValidateSamFile -I $markdup_bam >$validate");
	system("samtools index $markdup_bam");
	
	####SNP calling
	my $gvcf_dir = $snp_caller."/gvcf";
	system("mkdir $gvcf_dir") unless(-e $gvcf_dir);
	my $g_vcf = $gvcf_dir."/".$s.".g.vcf";
	
	###print OUT the run script, because the  gatk HaplotypeCaller model only can use one cpu, and can run multithreading in "gatk_gvcf.sh" file.
	print OUT "gatk --java-options '-Xmx60g'  HaplotypeCaller -R $ref_fa -I $markdup_bam -O $g_vcf --output-mode EMIT_VARIANTS_ONLY  -ERC GVCF \n";
}
close(OUT);

