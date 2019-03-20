#!/usr/bin/perl

=pod

    Simple demo of binomial expansion for instructional
    purposes.

    For a specified value of n ($n below) and a value of
    x ($r below), returns the values of the terms of the
    binomial expansion (x+y)**n, where in this case
    y is necessarily equal to 1 - x, thus the expansion
    sums to 1.

    In the output, p(n, k) for all k = 0 .. n are shown;
    notionally, n is a number of items (e.g. called
    nucleotides) and x is the probability of any item being
    in a state Z (e.g., called erroneously). Therefore
    p(n, k) is the probability of exactly k items being in
    state Z (in accordance with the sum of all p(n, k) being
    1).

    For each value of k, cumulative values p(n, <= k) are
    also shown, which in the above example would equate
    to the probability of 'no more than k items in state Z',
    e.g. no more than k of the n basecalls being wrong.

    Likewise, values p(n, >= k) are shown, i.e. probability
    of 'at least k items in state Z', e.g. at least k of the
    n basecalls being wrong.

    In the basecalls example, a necessary (and dubious)
    assumption would be that incorrect basecalls occur
    completely randomly, i.e. any position is equally likely
    (P = x) to be correct as any other, and with correctness
    of neighbouring positions being completely independent of
    each other.

    John Walshaw, 20-3-2019.

=cut

use strict;
use warnings;

my $n = shift; # notionally, e.g. number of positions

my $r = shift; # notionally, e.g. error rate

my $s = 1 - $r;

my @factorial_of;

my $sanity_sum = 0;

for my $k (0 .. $n) {

    my $p = C($n, $k) * $r**$k * $s**($n-$k);

    my $q = 1 - $sanity_sum;

    $sanity_sum += $p;

    printf qq{p(%3d,%3d) = %22.20f;  p(%3d, <= %3d) = %22.20f;  }.
           qq{p(%3d, >= %3d) = %22.20f\n},
      $n, $k, $p,
      $n, $k, $sanity_sum,
      $n, $k, $q;

}


exit 0;

=pod

    There are of course Perl modules to calculate combinations
    and factorials, but this script is for demo purposes.

=cut

sub C {

    my $n = shift;
    my $k = shift;

    return factorial($n) /
          (factorial($k) * factorial($n - $k));

}

sub factorial {

    my $x = shift;

    # used cached values to avoid recalculation

    return $factorial_of[$x] if defined $factorial_of[$x];

    if ($x == 0) {
        $factorial_of[$x] = 1;
        return 1;
    }

    $factorial_of[$x] = $x * factorial($x - 1);

    return $factorial_of[$x];

}

