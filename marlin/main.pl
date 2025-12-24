#!/usr/bin/env perl
use v5.42;
{
  # no warnings;
  use Marlin::Util -all, -lexical;
  use Types::Common -all, -lexical;

  package Person {
    use Marlin
      'given_name!'   => NonEmptyStr,
      'family_name!'  => NonEmptyStr,
      'name_style'    => { enum => [qw/western eastern/], default => 'western' },
      'full_name'     => { is => lazy, builder => true },
      'just_once'     => { is => lazy, builder => true },
      'x' => { builder => true },
      'birth_date?';
    
    sub _build_full_name($self) {
      return sprintf( '%s %s', uc($self->family_name), $self->given_name )
        if $self->name_style eq 'eastern';
      return sprintf( '%s %s', $self->given_name, $self->family_name );
    }

    sub _build_just_once($self) {
      say "----";
      state $v;
      if (defined $v) {
        return $v;
      } else {
        say 'setting v';
        $v = 'VVV';
        return $v;
      }
    }

    sub _build_x($self) { return 'x' }
    
    signature_for hello => (
      method => 1,
      named => [
        a => Str,
      ],
    );

    sub hello($self, $args) {
      say $args->a;
    }

    sub class_method($class) {
      say 'in class method';
    }
  }

  my $p = Person->new(
    given_name => 'brad',
    family_name => 'clawsie',
    # birth_date => '09/24/1970',
    x => 'X',
  );

  use Data::Dumper;
  warn Dumper $p;
  warn $p->full_name;
  if ($p->has_birth_date) {
    warn $p->birth_date;
  }
  warn $p->hello(a => 'hello!!');
  Person->class_method;
  warn "^^^^^^^^^^^";
  warn $p->just_once;
  warn "^^^^^^^^^^^";
  warn $p->just_once;
}

__END__
