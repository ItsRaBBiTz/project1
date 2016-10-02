#!usr/bin/perl -w

#####################################################################################################################
# Last modified date at: 2015年11月20日 周五 16時14分39秒 CST														#
# Author: Chuan-Fang																								#
# Description: Automatic running MutsigCV (bam to vcf, vcf to maf, merge mafs and Mutsig)							#
#			   The paired of tumor and normal sample are tab-seperated in each line of list_of_sample.txt			#
#			   Notice that name of tumor and normal sample in list_of_sample.txt must consistent with vcf			#
#			   Please check total numbers of silent and nonsilent in the total_merge.out.maf while running Mutsig	#
# Usage: perl auto_run_mutsig.pl list_of_sample.txt																	#
#####################################################################################################################

use warnings;
use strict;
use Time::HiRes qw(gettimeofday);
use Data::Dumper;

sub elasped_time {
	my ($s_time,$cur_time)=@_;
	my $elap_s=$cur_time-$s_time;
    my $ss=($elap_s % 60);
    my $mm=($elap_s/60)%60;
    my $hh=$elap_s/3600;
    my $local_time=localtime();
    printf $local_time." Elapsed time:%3d hr%3d min%3d sec\n\n",$hh,$mm,$ss;
}

my @temp_arr=();
my $local_time=localtime();
my $start_time=gettimeofday;
my $end_time=gettimeofday;
my $output="output";
my @total_file=();
my %marker=();
my $flag=0;
my $flag2=0;
my $temp=0;
my $temp2=0;

my $dir="/Users/chuanfang/Desktop/ratio/";
opendir (FILEDIR,"$dir");
my @filels= sort (grep { ! /^\.\.*/ } readdir  FILEDIR);
#my @filels = sort readdir(FILEDIR);
closedir(FILEDIR);

####################################################################################################################
# print Dumper(\%cytoband);
open (OUT, ">segmentedFile_del.txt");
open (OUT2, ">segmentedFile_amp.txt");
open (OUT3, ">markerfile.txt");

foreach my $file_name(@filels){
	my @aaa=split("T",$file_name);
	push(@total_file,$aaa[0]);
	# print $aaa[0]."T\t";
	open (IN, $dir.$file_name) || die print "Open $file_name file error\n";
	<IN>;
	while (<IN>){
		chomp $_;
		my @taba=split("\t",$_);
		my @colon=split(":",$taba[5]);
		my @dash=split("-",$colon[1]);
		
		# if($taba[4] < 2){
		# 	if($taba[0] ne "X"){
		# 		print OUT $aaa[0]."T\t"."$taba[0]\t$dash[0]\t$dash[1]\t20\t$taba[3]\n";
		# 	}
		# }
		# elsif($taba[4] > 2){
		# 	if($taba[0] ne "X"){
		# 		print OUT2 $aaa[0]."T\t"."$taba[0]\t$dash[0]\t$dash[1]\t20\t$taba[3]\n";
		# 	}
		# }
		if($taba[4] < 2){
			if($dash[0] < $dash[1]){
				if($flag==0){$temp=$dash[1];}
				elsif($flag==1 && $dash[0]+1==$temp){$dash[0]=$temp;}
				print OUT $aaa[0]."T\t"."$taba[0]\t$dash[0]\t$dash[1]\t20\t$taba[3]\n";
				$flag=1;
			}
			$temp=$dash[1];
		}
		elsif($taba[4] > 2){
			if($dash[0] < $dash[1]){
				if($flag2==0){$temp2=$dash[1];}
				elsif($flag2==1 && $dash[0]+1==$temp2){$dash[0]=$temp2;}
				print OUT2 $aaa[0]."T\t"."$taba[0]\t$dash[0]\t$dash[1]\t20\t$taba[3]\n";
				$flag2=1;
			}
			$temp2=$dash[1];
		}

		# if($flag==0){
		# 	print OUT3 "Marker".$dash[0]."\t$taba[0]\t$dash[0]\n";
		# 	print OUT3 "Marker".$dash[1]."\t$taba[0]\t$dash[1]\n";
		# 	$marker{$dash[0]}=1;
		# }
		# else{
		# 	if (not defined $marker{$dash[0]}) {
				print OUT3 "Marker".$dash[0]."\t$taba[0]\t$dash[0]\n";
				print OUT3 "Marker".$dash[1]."\t$taba[0]\t$dash[1]\n";
		# 		$marker{$dash[0]}=1;
		# 	}
		# }
		
		
				
	}
	close IN;
}

close OUT;
close OUT2;

 #print Dumper(\%total_file);