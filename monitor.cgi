#!/usr/bin/perl
use strict;
use CGI;
my $cgi=CGI->new();
my $htmlView='/tmp/testslow.html';
my $htmlPage="/var/www/html/$htmlView";
my $textPage='/var/www/html/tmp/testslow.txt';

RunSlowProgram($htmlPage, $htmlView, $textPage);

print $cgi->header();
my $page= '';
if(-e $htmlPage)
{
    $page = `cat $htmlPage`;
}
else
{
    $page="<html><head><title>Error</title></head><body><h1>Error: no HTML page</h1></body></html>";
}
    
$page    =~ s/\<meta.*?\>/<meta http-equiv='refresh' content="0; URL=$htmlView" \/\>/;
print $page;


sub RunSlowProgram
{
    my ($htmlPage, $htmlView, $textPage) = @_;

    unlink $textPage;
    unlink $htmlPage;
    sleep 1 while(-e $htmlPage);
    `nohup ./slowprogram.pl $htmlPage $htmlView $textPage &> /dev/null &`;
    sleep 1 while(! -e $htmlPage);
}

