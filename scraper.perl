#!/usr/bin/perl -w
use 5.30.0;
use LWP::UserAgent;
use HTML::TreeBuilder;
use HTML::FormatText;
use HTML::Element;
use Encode;
use warnings;
use open qw(:std :utf8);

#if ($#ARGV + 1 != 1) {
#  die "Please provide song input\n";
#}

my $ua = LWP::UserAgent->new;
$ua->agent("Mozilla/5.0 (X11; Linux i686; rv:10.0) Gecko/20100101 Firefox/10.0");

#my $url = "http://localhost:3020/?url=https://rjecnik.hr/?letter=a&page=2";#"$ARGV[0]";

my $formatter = HTML::FormatText->new(leftmargin => 0, rightmargin => 50);

my $root = HTML::TreeBuilder->new();

my $letter = "H";
my $page = 1;

my $document = `node index.js $letter $page`;

#my @letters = ("A","B","C","Č","Ć","D","Dž","Đ","E","F","G","H","I","J","K","L","Lj","M","N","Nj","O","P","R","S","Š","T","U","V","Z","Ž");



sub extract_grammar {
    my ($str) = @_;

    my $case = "";
    if( $str =~ /([A-Z]\s)/ ){
	$case = $1;
    }
    my @parts = $str  =~ /([a-z\x{017E}]+\.\s)/g;
    $str =~ /([^\s.A-Z]*)\s*$/;
    return $case,$1,@parts;
}



#if ($request->is_success) {
if (0==0){
    $root->parse($document);
    #my $out = $root->parse(decode_utf8 $request->content);
    #say $root->as_text;
    foreach my $tr ($root->look_down(_tag  => "tr")){
	my $word = ($tr->look_down(_tag => "span", class => "word"))[0]->as_trimmed_text;
	my $desc = ($tr->look_down(_tag => "div", class => "description"))[0]->as_trimmed_text;
      
	#if( $desc =~ /\x{2329}([\s\w]*[;,])*([\s\w]*)\x{232A}/ ){
	#	  foreach my $expr (1..$#-) {
	#	      print "Match $expr: '${$expr}' at position ($-[$expr],$+[$expr])\n";
	#	  }
	#     }
	my $filter = "[^;,\x{2329}\x{232A}]";
	#my $match = /\x{2329}[^;,\x{2329}\x{232A}]*?[;,]??([^;,\x{2329}\x{232A}]*).*\x{232A}/;
	#my @ts = $desc =~ $match;

	my $desc_copy = $desc;
	my $index = index($desc_copy,"\x{2329}");
	#print "desc_copy: $desc_copy index:$index\n";
	my @nom_parts = ();
	if( $index == -1 ){
	    @nom_parts = $desc_copy =~ /([a-z\x{017E}]+\.\s)/g;
	}else{
	    my $sub = substr($desc_copy,0,$index);
	    @nom_parts = $sub =~ /([a-z\x{017E}]+\.\s)/g;
	}
	
	print "forms: $word ";
	print "case: N parts:";
	print join(" | ", @nom_parts);
	print "\n";
	if( $desc =~ /\x{2329}(.*?)\x{232A}/ ){	  
	    my $snd = $1;
	    

	    my @words = $1 =~ /([^;,]*)[;,]/g;
	    push(@words, $snd =~ /^.*?[;,]?([^;,]*)$/);
	    foreach (@words){
		$_ =~ /^\s*(.*?)\s*$/;
		my ($case,$str,@parts) = extract_grammar($1);
		if ( $case eq "" ){
		    $case = "N";
		}
		my @forms = split(/\//,$str);
		print "forms: ";
		print join(" | ",@forms);
		print " case: $case parts: ";
		print join(" | ", @parts);
		print "\n";
	    }
	    print "*****************";
	}
	print "\n";
	#print join(" | ", @ts);
	#print "\n";
	#     while( $desc =~ $match ){
	#	  print "| $1";
	#}
	# print "\n";
	
    }    
    #say $formatter->format($data);
} else {  
  print "Cannot display.\n";
}
