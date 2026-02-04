#!/usr/bin/env perl
# use v5.42;
# use strictures 2;
# use UUID qw( uuid4 );
use object;

object::define('C', 'x:trigger(__trigger_x)', 'y');

package C;

sub _build_x ($self) {
  warn 'in _build_x';
  return 99;
}

sub _trigger_x {
  warn 'in _trigger_x';
}

package main;

my $c = C->new(y => 'Y');

use Data::Dumper;
warn Dumper $c;

$c->x('Z');
warn Dumper $c;

$c->x('ZZ');
warn Dumper $c;

__END__

