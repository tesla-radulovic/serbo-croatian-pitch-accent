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
$ua->agent("Rijecnik Scraper");

my $url = "https://rjecnik.hr/?letter=a&page=2";#"$ARGV[0]";

my $formatter = HTML::FormatText->new(leftmargin => 0, rightmargin => 50);

my $root = HTML::TreeBuilder->new();

my $request = $ua->get($url) or die "Cannot contact page $!\n";

if ($request->is_success) {
  $root->parse(decode_utf8 $request->content);
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

      print "$word: ";
      if( $desc =~ /\x{2329}(.*?)\x{232A}/ ){	  
	  my $snd = $1;
	  

	  my @words = $1 =~ /([^;,]*)[;,]/g;
	  push(@words, $snd =~ /^.*?[;,]?([^;,]*)$/);
	  print join(" | ", @words);
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
  print "Cannot display the lyrics.\n";
}
