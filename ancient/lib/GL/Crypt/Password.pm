package GL::Crypt::Password;
use v5.42;
use strictures 2;
use Crypt::Argon2               qw( argon2_verify argon2id_pass );
use Bytes::Random::Secure::Tiny ();
use Exporter                    qw( import );

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:bclawsie';

sub text_to_password ($text) {
  my $rng  = Bytes::Random::Secure::Tiny->new;
  my $salt = $rng->bytes_hex(8);
  return argon2id_pass($text, $salt, 1, '32M', 1, 16);
}

sub verify_password ($password, $text) {
  return argon2_verify($password, $text);
}

sub rand { text_to_password(Bytes::Random::Secure::Tiny->new->bytes_hex(8)) }

our @EXPORT_OK   = qw( text_to_password verify_password );
our %EXPORT_TAGS = (all => [qw( text_to_password verify_password )]);

__END__
