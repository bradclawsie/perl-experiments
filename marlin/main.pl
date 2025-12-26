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
    return $args->y;
  }

  signature_for fun => (
    method => false,
    named => [z => Str],
  );

  sub fun($args) {
    say $args->z;
  }

  signature_for fun2 => (
    method => false,
    named => [z => Str],
  );

  sub fun2($args) {
    my $hr = { z => 44 };
    __PACKAGE__::fun(%{$hr});
  }

  signature_for fun3 => (
    method => false,
    named => [z => Str],
  );

  sub fun3($args) {
    use UUID qw( uuid4 );
    return __PACKAGE__->new(
      id => uuid4,
      name => uuid4,
      ctime => time,
      mtime => time,
      role => 2,
      other => 'hello',
    );
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
say Org::fun2(z => 'ZZ');
my $org3 = Org::fun3(z => 'ZZ');
say $org3->role;

my $args = {
  id => uuid4,
  name => uuid4,
  ctime => time,
  mtime => time,
  role => 2,
  other => 'hello',
};

my $org2 = Org->new($args);

__END__
