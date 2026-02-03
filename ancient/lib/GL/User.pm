package GL::User;
use v5.42;
use strictures 2;
use Crypt::Digest::SHA256 qw( sha256_hex );

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:bclawsie';

sub build ($self) {
  $self->display_name_digest(sha256_hex($self->display_name));
  $self->email_digest(sha256_hex($self->email));

  # other fields...
  return $self;
}

sub random {

  # use GL::Types ();
  # return new random
}

__END__
