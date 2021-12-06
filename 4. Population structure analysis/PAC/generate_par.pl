#!/usr/bin/perl 
use strict;
use warnings;

open(FA, "./chr1-10_filtered3.ped");
open(FB, "./population.txt");

open(OUTA, ">./pca.ped");
open(OUTB, ">./pca.pedind");

my %individual2family;
while(<FB>){
	s/\s+$//;
	my ($individual, $family)=split/\t/;
	$individual2family{$individual}=$family;
}

my @a=<FA>;
foreach(@a){
	s/S\.officinarum_//g;
	s/\s+/ /g;
	my @t=split/ /;
	$t[0]=$individual2family{$t[0]};
	$t[5]=1;
	my @outa=();
	my @outb=();
	for(my $i=0;$i<$#t;$i++){
		push(@outa, $t[$i]);
	}
	for(my $i=0;$i<6;$i++){
		push(@outb, $t[$i]);
	}
	print OUTA join("\t", @outa);
	print OUTA "\n";
	print OUTB join("\t", @outb);
	print OUTB "\n";
}
`cp chr1-10_filtered3.map pca.pedsnp`;

open(OUT, ">./smartpca.par");
while(<DATA>){
	print OUT;
}

close(OUT);
close(OUTA);
close(OUTB);
close(FA);
close(FB);
__DATA__
genotypename:    pca.ped
snpname:         pca.pedsnp
indivname:       pca.pedind
evecoutname:    pca.vec
evaloutname:    pca.val
numoutlieriter:    0
numchrom:    10