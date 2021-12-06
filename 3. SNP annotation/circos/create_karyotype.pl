#!/usr/bin/perl
use strict;
use warnings;

my ($file)=@ARGV;
open(F, $file)or die "Can not open the genome sequence file\n";
open(OUT, ">data/karyotype.sorghum.txt");

my @a=<F>;
my $i=0;
while($i<=$#a){
	my $j = $i + 1;
	if($a[$i]=~/NC_01287(\d+)\.2/){
		my $chr=$1+1;
		$a[$i]=~s/NC_01287\d+\.2/$chr/;
		my $len=0;
		while($j<=$#a){
			if($a[$j]=~/^>/){
				last;
			}else{
				$a[$j]=~s/\s+$//;
				$len = $len + length($a[$j]);
			}
			$j++;
		}
		my $chr_marker = "Chr".$chr;
		my $chr_name = "chr".$chr;
		my $chr_alias_name = "sb".$chr;
		print OUT "chr"."\t"."-"."\t".$chr_alias_name."\t".$chr_marker."\t"."0"."\t".$len."\t".$chr_name."\n";
	}
	$i = $j;
}	
	
