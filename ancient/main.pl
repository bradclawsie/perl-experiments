#!/usr/bin/env perl
use v5.42;
use strictures 2;
use UUID qw( uuid4 );

use GL::Types;
use GL::Runtime;

my $t = time;
my $meta = GL::Meta->new(
  id => uuid4,
);
use Data::Dumper;
warn Dumper $meta;

my $rt = GL::Runtime->new(GL::Runtime::for_test);
warn Dumper $rt;

__END__

