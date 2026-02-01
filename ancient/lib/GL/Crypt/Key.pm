package GL::Crypt::Key;
use v5.42;
use strictures 2;
use Bytes::Random::Secure::Tiny ();

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:bclawsie';

sub rand { Bytes::Random::Secure::Tiny->new->bytes_hex(16) }

__END__
