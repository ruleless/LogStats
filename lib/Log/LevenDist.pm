package Log::LevenDist;

use strict;
use warnings;

use List::Util qw(min max);

# 函数导出定义
use Exporter qw(import);

our @EXPORT = qw(leven_dist);
our @EXPORT_OK = qw(similarity_of_str);

=head1 NAME

Log::LevenDist - calculate Levenshtein distance between two string

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Log::LevenDist qw(leven_dist similarity_of_str);

    my $dist = leven_dist 'Hello', 'Hello World';
    my $similarity = similarity_of_str('Hello', 'Hello World');

=cut

=head1 METHODS

=cut

sub calc_leven_dist_by_dp {
    my ($s1_ref, $s2_ref, $i, $j, $dp_ref) = @_;

    if ($i == 0) {
        return $j;
    }
    if ($j == 0) {
        return $i;
    }

    if (defined($dp_ref->[$i][$j])) {
        return $dp_ref->[$i][$j];
    }

    my $d1 = calc_leven_dist_by_dp($s1_ref, $s2_ref, $i - 1, $j, $dp_ref);
    my $d2 = calc_leven_dist_by_dp($s1_ref, $s2_ref, $i, $j - 1, $dp_ref);
    my $d3 = calc_leven_dist_by_dp($s1_ref, $s2_ref, $i - 1, $j - 1, $dp_ref);
    my $chr_i = substr $$s1_ref, $i - 1, 1;
    my $chr_j = substr $$s2_ref, $j - 1, 1;

    $dp_ref->[$i][$j] = min($d1 + 1, $d2 + 1, $d3 + !($chr_i eq $chr_j));
    return $dp_ref->[$i][$j];
}

=head2 leven_dist

求两个字符串之间的 Levenshtein 距离，亦即编辑距离

=cut

sub leven_dist {
    my ($s1, $s2) = @_;
    die 'invalid parameters' unless defined($s1) and defined($s2);

    my @dp;
    return calc_leven_dist_by_dp \$s1, \$s2, length $s1, length $s2, \@dp;
}

=head2 similarity_of_str

求两个字符串之间的相似性

=cut

sub similarity_of_str {
    my ($s1, $s2) = @_;
    die 'invalid parameters' unless defined($s1) and defined($s2);

    my $max_len = max(length $s1, length $s2);
    if ($max_len == 0) {
        return 0;
    }

    my $dist = leven_dist($s1, $s2);
    return 1 - $dist / $max_len;
}

1; # End of Log::LevenDist
