#!/usr/bin/perl
use strict;
use CGI qw(:cgi);
print header (), "<p><b>Hi, people! Mod_perl work Ok.</b></p>";
print header (), "<p><b>Perl version: ", $^V, "</b></p>";
#print "Content-type: text/plain \r \n \r \n";
print "<p>Server's environment </p>";
foreach ( keys %ENV ) {
    print "<p>$_\t$ENV{$_}</p>";
}
