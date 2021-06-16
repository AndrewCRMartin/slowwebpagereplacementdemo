#!/usr/bin/perl
use strict;
use CGI;

my $htmlPage = shift @ARGV;
my $htmlView = shift @ARGV;
my $textPage = shift @ARGV;

`touch $textPage`;

PrintUpdatingHTMLPage($htmlPage);
DoSlowStuff($textPage);
PrintFinalHTMLPage($htmlPage, $textPage);

sub PrintFinalHTMLPage
{
    my($htmlPage, $textPage) = @_;

    if(open(my $in, '<', $textPage))
    {
        if(open(my $out, '>', $htmlPage))
        {
            print $out <<__EOF;
<html>
  <head>
    <title>Slow page results</title>
  </head>
  <body>
    <h1>Slow page results</h1>
    <pre>
__EOF
            while(<$in>)
            {
                print $out $_;
            }
            print $out <<__EOF;
    </pre>
  </body>
</html>
__EOF
            close $out;
        }
        close $in;
    }
}



sub DoSlowStuff
{
    my($textPage) = @_;

    for(my $count=0; $count<3; $count++)
    {
        sleep 5;
        if(open(my $fp, '>>', $textPage))
        {
            print $fp localtime(time()) . "\n";
            close $fp;
        }
    }
}

sub PrintUpdatingHTMLPage
{
    my($htmlPage) = @_;

    if(open(my $fp, '>', $htmlPage))
    {
        print $fp <<__EOF;
<html>
  <head>
    <title>Slow program wait...</title>
    <meta http-equiv="refresh" content="10" />
  </head>
  <body>
    <h1>Waiting for page to complete...</h1>
    <p>If this page does not refresh after 10 second, press 
      <a href='$htmlView'>here</a>
    </p>
  </body>
</html>
__EOF
        close $fp;
    }
}
