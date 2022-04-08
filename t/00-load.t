#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 2;

BEGIN {
    use_ok( 'Log::Stats' ) || print "Bail out!\n";
    use_ok( 'Log::LevenDist' ) || print "Bail out!\n";
}

diag( "Testing Log::Stats $Log::Stats::VERSION, Perl $], $^X" );
