#!/usr/bin/perl
use strict;
use warnings;

my ($file)=@ARGV;
unless(-e $file){
	print "Can not open the annoation file of sorghum genome\n";
	exit 0;
}

my $tmp_file = $file;
$tmp_file=~s/\.(\S+)$/tmp/;
if($file=~/\.gtf/){
	system("gtfToGenePred $file $tmp_file");
}elsif($file=~/\.gff3/){
	my $gtf=~s/gff3/gtf/;
	system("gffread $file -T -o $gtf");
	system("gtfToGenePred $gtf $tmp_file");
}

my $gpd="data/gene.gpd";
system("cut -f1-2,4-5 $tmp_file >$gpd");
system("rm $tmp_file");
