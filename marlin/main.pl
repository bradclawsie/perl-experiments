#!/usr/bin/env perl
use v5.42;

package Model {
  use Marlin::Util -all, -lexical;
  use Types::Common -all, -lexical;
  use Types::UUID;
  use Marlin::Role
    -requires => [qw/insert read fun/],
    'id!' => Uuid,
    'ctime==!' => PositiveOrZeroInt,
    'mtime==!' => PositiveOrZeroInt,
    'role!' => { enum => [1,2,3], default => 1 },
    ;

    signature_for update_status => (
      method => true,
      named => [z => Int],
    );

    sub update_status ($self, $args) {
      return $args->z;
    }
}

package Org {
  use Marlin::Util -all, -lexical;
  use Types::Common -all, -lexical;
  use Marlin
    -with => [qw/Model/],
    'name!' => NonEmptyStr,
    'other' => { isa => sub($v) { say "V:$v"; } },
    ;

  signature_for insert => (
    method => true,
    named => [x => Str],
  );

  sub insert ($self, $args) {
    return $args->x;
  }

  signature_for read => (
    method => true,
    named => [y => Str],
  );

  sub read ($self, $args) {
    return $self->insert(x => $args->y);
  }

  signature_for fun => (
    method => false,
    named => [z => Str],
  );

  sub fun($args) {
    say $args->z;
  }
}

use UUID qw( uuid4 );
my $org = Org->new(
  id => uuid4,
  name => uuid4,
  ctime => time,
  mtime => time,
  role => 2,
  other => 'hello',
);

say $org->insert(x => 'X');
say $org->read(y => 'Y');
say $org->update_status(z => 99);
say Org::fun(z => 'ZZ');
say $org->role;

my $args = {
  id => uuid4,
  name => uuid4,
  ctime => time,
  mtime => time,
  role => 2,
  other => 'hello',
};

my $org2 = Org->new($args);

say "calling method as if static";
say Org->read(y => 'FF');

__END__
