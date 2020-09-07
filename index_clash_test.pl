#!/usr/bin/env perl 

use strict;
use warnings;
use Getopt::Long;



my %options;

my $usage = 'This script takes two index sequence files and checks for
the index sequence mismatches between index list. For Each index in 
list 1, the mismatches for each index in list2 are counted and 
represented as matrix.

USAGE:
perl index_clash_test.pl --ind1 <index_list1.tab> --ind2 <index_list2.tab>
';

GetOptions(\%options, 'ind1=s', 'ind2=s', 'help|h') or die("Error in command line arguments\n");

if(!$options{'ind1'}){
	print STDERR "Error: Please provide the index 1 file\n";
	die $usage;
}


if(!$options{'ind2'}){
	print STDERR "Error: Please provide the index 2 file\n";
	die $usage;
}


my %ind1 = ();
my @ind1Ids = ();

open(my $fh1, $options{'ind1'}) or die "Cannot open index file ",$options{'ind1'},"\n";

while(<$fh1>){
	chomp;
	my @tmp = split(/\t/, $_);
	$ind1{$tmp[0]} = $tmp[1];
	push(@ind1Ids, $tmp[0]);
}

close($fh1);


##
print "sampleId\t.\t",join("\t", @ind1Ids),"\n";
print ".\tindex\t",join("\t", @ind1{@ind1Ids}),"\n";

open(my $fh2, $options{'ind2'}) or die "Cannot open index file ",$options{'ind2'},"\n";

while(<$fh2>){
	chomp;
	my @tmp = split(/\t/, $_);
	
	my @indexMismatches = ();
	push(@indexMismatches, @tmp);
	
	## find the mismatch between the each index sequence of list1 with current index sequence
	foreach my $i1(@ind1Ids){
		my $mismatch = index_match($ind1{$i1}, $tmp[1]);
		push(@indexMismatches, $mismatch);
	}
	
	print join("\t", @indexMismatches),"\n";
	
	# last;
	
}

close($fh2);











## sample code for sequence mismatch count
# my $s1 = 'ATGCCAT';
# my $s2 = 'ATGCAATAA';

# my $x = $s1 ^ $s2;
# print "|",$x,"|\n";
# $x =~ tr/\0//d;
# print "|",$x,"|\n";
# print length($x),"\n";

# print length($s1) - ( ( $s1 ^ $s2 ) =~ tr/\0// ),"\n";

sub index_match{
	my ($s1, $s2) = ('', '');
	
	## ensure that shorter sequence is $s1 and longer is $s2
	if(length($_[0]) < length($_[1])){
		$s1 = $_[0];
		$s2 = $_[1];
	}
	elsif(length($_[0]) > length($_[1])){
		$s1 = $_[1];
		$s2 = $_[0];
	}
	else{
		$s1 = $_[0];
		$s2 = $_[1];
	}
	
	
	my $mismatches = length($s1) - ( ( $s1 ^ $s2 ) =~ tr/\0// );
	
	return $mismatches;
}











