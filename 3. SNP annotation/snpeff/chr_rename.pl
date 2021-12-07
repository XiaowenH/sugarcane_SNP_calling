#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

sub usage{
    print <<USAGE;
Name:
    $0
Description:
Rename of sorghum chromosome name to num.
Update:
    2021-10-25  edit by Xiao-wen Hu
Usage:
    perl $0 <in> <out> 
Options:
    -i, --in       <string>*   clade_s tsv file
    -o, --outfile    <string>    output directory            [default: ./ ]
    -h, --help                        print this help information
e.g
    perl $0 -in GCF_000003195.3_Sorghum_bicolor_NCBIv3_genomic.fna -o sequence.fa
USAGE
    exit 0;
}

my ($help,$in,$outfile);
GetOptions(
    "in|i=s"  => \$in,
    "outfile|o:s" => \$outfile,
    "help|h"     => \$help
);
die &usage if (!defined $in || !defined $outfile || defined $help);

$outfile ||= ".";

open(FA,$in) || die "Can't open the clade_s tsv file $!\n";
my @a=<FA>;

open(OUTA, ">$outfile");


foreach(@a){
	if(/NC_01287/){
		s/NC_012870\.2/1/;
		s/NC_012871\.2/2/;
		s/NC_012872\.2/3/;
		s/NC_012873\.2/4/;
		s/NC_012874\.2/5/;
		s/NC_012875\.2/6/;
		s/NC_012876\.2/7/;
		s/NC_012877\.2/8/;
		s/NC_012878\.2/9/;
		s/NC_012879\.2/10/;
	}
	print OUTA;
}
