#!/usr/bin/env perl
use v5.42;
use strictures 2;
use UUID qw( uuid4 );

use GL::Types;
use GL::Runtime;
use GL::Crypt::Key;

my $t = time;
my $meta = GL::Meta->new(
  id => uuid4,
);
use Data::Dumper;

my $rt = GL::Runtime->new(GL::Runtime::for_test);
warn Dumper $rt;

my $key = GL::Crypt::Key->new(GL::Crypt::Key::rand);
warn Dumper $key->value;

__END__

