#!/usr/bin/perl
#
# This script checks a LaTex file to generate a BibTex file that contains all the PubMed citations.  
# The citation key for PubMed entries is 
# \citep{pmid123456789}
# The PMCID are included in the Note section, which can be used with many existing bty files to generate 
# references for NIH grants
# Author: Hao Chen (inbox @ haochen . name)
# License: Creative Commons Attribution 4.0 International 

use LWP::Simple qw(get);

$tex=$ARGV[0];
$bib="bb".$ARGV[0];
$bib=~s/\.tex/\.bib/;

open(B, $bib) || print "No bibtex file found, a new one will be generated\n";
while (<B>){
	$b.=$_;
}
close(B);

while ($b=~s/pmid(\d+)//){;
	$bib_t{$1}=1;
#	print "$1;";
}


open(T, $tex) || die "The main LaTex file $tex is missing!"; 
while(<T>) {
	$t.=$_;
}
	
## get missing bibtex entries 
while ($t=~s/pmid(\d+)//){;
	if (!$bib_t{$1}) {
		$add.=&getRef($1). "\n";
		$bib_t{$1}=1;
	}
}

open (C, ">>",$bib);
print C $add;
if ($add) {
	print "The following was added to the $bib file\n$add";
} else {
	print "No new entry was added.\n";
}
close(C);


sub getRef{
	my $pmid=shift;
	my $xml=get("http://130.14.29.110/entrez/eutils/efetch.fcgi?db=pubmed&id=$pmid&retmode=xml&rettype=citation");
#	print $xml;
	$xml =~m|<AuthorList(.+)</AuthorList>|s ;
	my @authors=split(/\n/, $1);
	foreach (@authors) {
		next if ($_ !~m/LastName|Initials/);
		$_=~m|<LastName>(.+)</LastName>|s;
		$_=~m|<Initials>(.+)</Initials>|s;
		$author.=$1;
		if ($_=~m|Initials|s) {
			$author.=". and  ";
		} else {
			$author.=", ";
		}
	}
	$author=~s/and  $//;
	if (!$author){
		$author="{{".$1."}}" if ($xml=~m|<CollectiveName>(.+)</CollectiveName>|);
	}
	my $journal=$1 if ($xml=~m|<MedlineTA>(.+)</MedlineTA>|s);
	my $year =$1 if ($xml=~m|<PubDate>\s+<Year>(.+)</Year>.+</PubDate>|s);
	my $vol=$1 if ($xml =~m|<JournalIssue.+>\s+<Volume>(\d+)</Volume>|s);
	my $iss=$1 if ($xml=~m|<Issue>(.+)</Issue>|s);
	my $page=$1 if ($xml=~m|<MedlinePgn>(.*)</MedlinePgn>|s);
	if ($page=~m|(\d+)-(\d+)|) {
		my $start=$1;
		my $end=$2;
		my $lenDiff=length($start)-length($end);
		$end=substr($start,0,$lenDiff).$end;
		$page=$start."-".$end;
	}
	my $pmcid=$1 if ($xml=~m|(PMC\d\d\d\d\d+)|);
	my $title=$1 if ($xml=~m|<ArticleTitle>(.*)</ArticleTitle>|s);
	$title=~s/^(.)/\{$1\}/;
	$title=~s/\.$//;
	my $bib= "\@Article{pmid$pmid,\n\tAuthor=\"$author\",\n\tTitle=\"\{$title \}\",\n\tJournal=\"$journal\",\n\tYear=\"$year\",\n\tVolume=\"$vol\",\n\tNumber=\"$iss\",\n\tPages=\"$page\"";
	if ($pmcid) {	
		$bib.= ",\n\tNote=\{\{PMCID\}: $pmcid, \{PMID}: $pmid\}"; 
	} else {
		$bib.= ",\n\tNote=\{\{PMID\}: $pmid\}" ;
	}
	$bib.= "\n\}\n";
	$author=$title=$journal=$year=$vol=$iss=$page="";
	undef (@authors);
	return $bib;
}


